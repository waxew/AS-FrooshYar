import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:packages/bluetooth.dart' as bt;
import 'package:possystem/app.dart';
import 'package:possystem/components/imageable_container.dart';
import 'package:possystem/components/style/snackbar.dart';
import 'package:possystem/constants/constant.dart';
import 'package:possystem/helpers/launcher.dart';
import 'package:possystem/helpers/logger.dart';
import 'package:possystem/models/model.dart';
import 'package:possystem/models/model_object.dart';
import 'package:possystem/models/objects/order_object.dart';
import 'package:possystem/models/repository.dart';
import 'package:possystem/services/bluetooth.dart';
import 'package:possystem/services/storage.dart';
import 'package:possystem/translator.dart';
import 'package:possystem/ui/order/widgets/checkout_receipt_dialog.dart';

typedef BluetoothDevice = bt.BluetoothDevice;
typedef PrinterManufactory = bt.PrinterManufactory;

class Printers extends ChangeNotifier with Repository<Printer>, RepositoryStorage<Printer> {
  static late Printers instance;

  PrinterDensity density = PrinterDensity.normal;

  @override
  final Stores storageStore = .printers;

  Printers() {
    instance = this;
  }

  @override
  List<Printer> get itemList => items.sorted((a, b) => a.compareTo(b));

  @override
  RepositoryStorageType get repoType => .repoModel;

  bool get hasConnected => items.any((e) => e.connected);

  List<int> get wantedPixelsWidths =>
      items.where((e) => e.connected).map((e) => e.p.manufactory.widthBits).toSet().toList();

  bool hasAddress(String address) => items.any((e) => e.address == address);

  @override
  Printer buildItem(String id, Map<String, Object?> value) {
    return Printer.fromObject(PrinterObject.build({'id': id, ...value}));
  }

  @override
  Future<void> initialize({String? record}) async {
    await super.initialize(record: 'printer');

    final data = await Storage.instance.get(storageStore, 'setting');
    density = PrinterDensity.values.elementAtOrNull(data['density'] as int? ?? 0) ?? PrinterDensity.normal;

    if (isEmpty && data.isEmpty) {
      await Future.wait([
        Storage.instance.add(storageStore, 'setting', {'density': density.index}),
        Storage.instance.add(storageStore, 'printer', {}),
      ]);
    }
  }

  Future<void> changeDensity(PrinterDensity newDensity) {
    density = newDensity;
    return _saveProperties();
  }

  Future<List<ConvertibleImage>?> generateReceipts({required BuildContext context, required OrderObject order}) {
    if (!Printers.instance.hasConnected) {
      return Future.value(null);
    }
    return CheckoutReceiptDialog.show(context, order, wantedPixelsWidths);
  }

  void printReceipts(List<ConvertibleImage> images) async {
    final errors = <Object>[];
    final stackTraces = <StackTrace>[];

    final printers = Printers.instance.items.where((e) => e.connected);
    final group = printers.groupListsBy<int>((e) => e.p.manufactory.widthBits);
    final futures = group.entries
        .map((entry) {
          final image = images.firstWhere((e) => e.width == entry.key);
          return entry.value.map(
            (printer) => printer.draw(image.bytes).drain().onError((e, s) {
              errors.add('${printer.name}: $e');
              stackTraces.add(s);
              return 1;
            }),
          );
        })
        .expand((e) => e);

    await Future.wait(futures);

    if (errors.isNotEmpty) {
      showSnackbarWhenFutureError(Future.error(errors.join('\n')), 'printer_draw', key: App.scaffoldMessengerKey);
    }
  }

  Future<void> _saveProperties() async {
    Log.ger('update_repo', {'type': storageStore.name, 'density': density.index});
    await Storage.instance.set(storageStore, {
      'setting': {'density': density.index},
    });
    notifyListeners();
  }
}

class Printer extends Model<PrinterObject> with ModelStorage<PrinterObject> implements Comparable<Printer> {
  String address;
  bool autoConnect;
  PrinterProvider provider;
  bt.Printer p;

  @override
  final Stores storageStore = .printers;

  @override
  Printers get repository => .instance;

  @override
  String get prefix => 'printer.$id';

  bool get connected => isLocalTest ? true : p.connected;

  Printer({
    super.id,
    super.status = ModelStatus.normal,
    super.name = 'printer',
    this.address = '',
    this.autoConnect = false,
    this.provider = PrinterProvider.catPrinter,
    bt.Printer? other,
  }) : p = bt.Printer(address: address, manufactory: provider.manufactory, other: other) {
    p.addListener(notifyItem);
  }

  factory Printer.fromObject(PrinterObject object) => Printer(
    id: object.id,
    name: object.name!,
    address: object.address!,
    autoConnect: object.autoConnect!,
    provider: PrinterProvider.values[object.provider!],
  );

  @override
  PrinterObject toObject() =>
      PrinterObject(id: id, name: name, address: address, autoConnect: autoConnect, provider: provider.index);

  @override
  Future<void> remove() async {
    await p.disconnect();
    await super.remove();
  }

  Future<bool> connect() {
    Log.ger('connect_printer');
    return p.connect();
  }

  Future<void> disconnect() {
    Log.ger('disconnect_printer');
    return p.disconnect();
  }

  Stream<double> draw(Uint8List image) {
    Log.out('start', 'printer_draw');
    return p.draw(image, density: Printers.instance.density);
  }

  @override
  int compareTo(Printer other) {
    int myScore = 0;
    if (connected) myScore -= 2;
    if (autoConnect) myScore -= 1;

    int otherScore = 0;
    if (other.connected) otherScore -= 2;
    if (other.autoConnect) otherScore -= 1;
    return myScore.compareTo(otherScore);
  }
}

class PrinterObject extends ModelObject<Printer> {
  final String? id;
  final String? name;
  final String? address;
  final bool? autoConnect;
  final int? provider;

  PrinterObject({this.id, this.name, this.address, this.autoConnect, this.provider});

  @override
  Map<String, Object> toMap() =>
      {'name': name!, 'address': address!, 'autoConnect': autoConnect!, 'provider': provider!};

  @override
  Map<String, Object> diff(Printer model) {
    final result = <String, Object>{};
    final prefix = model.prefix;

    if (name != null && name != model.name) {
      model.name = name!;
      result['$prefix.name'] = name!;
    }
    if (autoConnect != null && autoConnect != model.autoConnect) {
      model.autoConnect = autoConnect!;
      result['$prefix.autoConnect'] = autoConnect!;
    }
    return result;
  }

  factory PrinterObject.build(Map<String, Object?> data) => PrinterObject(
    id: data['id'] as String,
    name: data['name'] as String,
    address: data['address'] as String,
    autoConnect: data['autoConnect'] as bool,
    provider: data['provider'] as int,
  );
}

enum PrinterProvider {
  catPrinter(bt.CatPrinter(feedPaperByteSize: 1)),
  catPrinter2(bt.CatPrinter(feedPaperByteSize: 2)),
  xPrinter58(bt.CatPrinter(), link: 'https://www.xprinter.net/', markers: ['XP-58', 'XP-76', 'XP-80']),
  xPrinter76(bt.CatPrinter()),
  xPrinter80(bt.CatPrinter()),
  yokoscan58(bt.CatPrinter(), link: 'https://yokoscan.net/product/product.php?class2=184'),
  yokoscan80(bt.CatPrinter());

  final PrinterManufactory manufactory;
  final String? link;
  final List<String> markers;

  const PrinterProvider(this.manufactory, {this.link, this.markers = const []});

  static PrinterProvider? tryGuess(String name) {
    Log.out('guess printer name: $name', 'printer');
    for (final provider in PrinterProvider.values) {
      if (provider.markers.any((marker) => name.toUpperCase().contains(marker.toUpperCase()))) {
        return provider;
      }
    }
    return null;
  }

  void launchUrl() {
    if (link == null) {
      Launcher.launch('https://www.google.com/search?q=${S.printerSupportedName(name)}').ignore();
    } else {
      Launcher.launch(link!).ignore();
    }
  }
}

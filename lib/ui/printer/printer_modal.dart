import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:possystem/components/style/buttons.dart';
import 'package:possystem/components/style/snackbar.dart';
import 'package:possystem/constants/constant.dart';
import 'package:possystem/models/printer.dart';
import 'package:possystem/services/bluetooth.dart';
import 'package:possystem/translator.dart';

class PrinterModal extends StatefulWidget {
  final Printer? printer;

  const PrinterModal({super.key, this.printer});

  bool get isNew => printer == null;

  static Future<void> show(BuildContext context, [Printer? printer]) {
    return showDialog<void>(context: context, builder: (context) => PrinterModal(printer: printer));
  }

  @override
  State<PrinterModal> createState() => _PrinterModalState();
}

class _PrinterModalState extends State<PrinterModal> {
  final nameController = TextEditingController();
  final searched = <BluetoothDevice>[];
  bool autoConnect = false;
  PrinterProvider? provider;
  BluetoothDevice? selectedDevice;

  @override
  void initState() {
    super.initState();
    final printer = widget.printer;
    if (printer != null) {
      nameController.text = printer.name;
      autoConnect = printer.autoConnect;
      provider = printer.provider;
    }
    _makeSureDebugHasDemo();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNew ? S.printerTitleCreate : S.printerTitleUpdate),
      scrollable: true,
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: S.printerNameLabel),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: autoConnect,
              onChanged: (value) => setState(() => autoConnect = value),
              title: Text(S.printerAutoConnectLabel),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text(provider?.name ?? S.printerTypeSelectTitle),
              trailing: const Icon(Icons.chevron_left),
              onTap: () async {
                final result = await _ManualTypeSelection.show(context, initial: provider);
                if (result != null && mounted) setState(() => provider = result);
              },
            ),
            if (searched.isNotEmpty) ...[
              const Divider(),
              ...searched.map(
                (device) => RadioListTile<BluetoothDevice>(
                  value: device,
                  groupValue: selectedDevice,
                  onChanged: (value) => setState(() => selectedDevice = value),
                  title: Text(device.name.isEmpty ? device.address : device.name),
                  subtitle: Text(device.address),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        PopButton(title: MaterialLocalizations.of(context).cancelButtonLabel),
        ElevatedButton(onPressed: _submit, child: Text(MaterialLocalizations.of(context).okButtonLabel)),
      ],
    );
  }

  Future<void> _submit() async {
    final object = parseObject();
    final selectedProvider = provider ?? PrinterProvider.catPrinter;

    if (widget.isNew) {
      final device = selectedDevice;
      if (device == null) {
        showSnackbarWhenFutureError(Future.error(S.printerErrorNotFound), 'printer_create', context: context);
        return;
      }
      final item = Printer(
        name: object.name!,
        address: device.address,
        autoConnect: object.autoConnect!,
        provider: selectedProvider,
      );
      await Printers.instance.addItem(item);
    } else {
      await widget.printer!.update(object);
    }

    if (mounted && context.canPop()) context.pop();
  }

  PrinterObject parseObject() => PrinterObject(name: nameController.text, autoConnect: autoConnect);

  void _makeSureDebugHasDemo() {
    // The public printer compatibility package intentionally has no synthetic
    // Bluetooth demo device. Keep the list empty instead of calling a removed API.
    if (kDebugMode && searched.isEmpty) return;
  }
}

class _ManualTypeSelection extends StatefulWidget {
  final PrinterProvider? initial;

  const _ManualTypeSelection({super.key, this.initial});

  static Future<PrinterProvider?> show(BuildContext context, {PrinterProvider? initial}) async {
    return showDialog<PrinterProvider>(
      context: context,
      builder: (context) => _ManualTypeSelection(initial: initial),
    );
  }

  @override
  State<_ManualTypeSelection> createState() => _ManualTypeSelectionState();
}

class _ManualTypeSelectionState extends State<_ManualTypeSelection> {
  PrinterProvider? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.printerTypeSelectTitle),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: PrinterProvider.values
            .map(
              (item) => RadioListTile<PrinterProvider>(
                value: item,
                groupValue: selected,
                title: Text(item.name),
                onChanged: (value) => setState(() => selected = value),
              ),
            )
            .toList(),
      ),
      actions: [
        PopButton(title: MaterialLocalizations.of(context).cancelButtonLabel),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(selected), child: Text(MaterialLocalizations.of(context).okButtonLabel)),
      ],
    );
  }
}

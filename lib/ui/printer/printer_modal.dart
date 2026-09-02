import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final addressController = TextEditingController();
  bool autoConnect = false;
  PrinterProvider? provider;

  @override
  void initState() {
    super.initState();
    final printer = widget.printer;
    if (printer != null) {
      nameController.text = printer.name;
      addressController.text = printer.address;
      autoConnect = printer.autoConnect;
      provider = printer.provider;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
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
            TextField(controller: nameController, decoration: InputDecoration(labelText: S.printerNameLabel)),
            const SizedBox(height: 12),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'آدرس چاپگر')),
            const SizedBox(height: 12),
            SwitchListTile(
              value: autoConnect,
              onChanged: (value) => setState(() => autoConnect = value),
              title: const Text('اتصال خودکار'),
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
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        ElevatedButton(onPressed: _submit, child: Text(MaterialLocalizations.of(context).okButtonLabel)),
      ],
    );
  }

  Future<void> _submit() async {
    final name = nameController.text.trim();
    final address = addressController.text.trim();
    if (name.isEmpty || address.isEmpty) return;

    if (widget.isNew) {
      await Printers.instance.addItem(Printer(
        name: name,
        address: address,
        autoConnect: autoConnect,
        provider: provider ?? PrinterProvider.catPrinter,
      ));
    } else {
      await widget.printer!.update(PrinterObject(name: name, autoConnect: autoConnect));
    }

    if (mounted && context.canPop()) context.pop();
  }
}

class _ManualTypeSelection extends StatefulWidget {
  final PrinterProvider? initial;

  const _ManualTypeSelection({this.initial});

  static Future<PrinterProvider?> show(BuildContext context, {PrinterProvider? initial}) {
    return showDialog<PrinterProvider>(context: context, builder: (context) => _ManualTypeSelection(initial: initial));
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: PrinterProvider.values.map((item) => ListTile(
          title: Text(item.name),
          leading: Icon(selected == item ? Icons.radio_button_checked : Icons.radio_button_off),
          onTap: () => setState(() => selected = item),
        )).toList(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(selected), child: Text(MaterialLocalizations.of(context).okButtonLabel)),
      ],
    );
  }
}

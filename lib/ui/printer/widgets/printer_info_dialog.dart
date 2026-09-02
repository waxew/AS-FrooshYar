import 'package:flutter/material.dart';
import 'package:possystem/components/style/buttons.dart';
import 'package:possystem/models/printer.dart';
import 'package:possystem/services/bluetooth.dart';
import 'package:possystem/translator.dart';

class PrinterInfoDialog extends StatelessWidget {
  final Printer printer;

  const PrinterInfoDialog({super.key, required this.printer});

  static Future<bool?> show(BuildContext context, Printer printer) {
    return showDialog<bool>(context: context, builder: (context) => PrinterInfoDialog(printer: printer));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(printer.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(printer.address),
          const SizedBox(height: 8),
          Text(printer.provider.name),
        ],
      ),
      actions: [
        PopButton(title: MaterialLocalizations.of(context).cancelButtonLabel),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(printer.connected ? S.printerBtnDisconnect : S.printerBtnConnect),
        ),
      ],
    );
  }
}

const signalIcons = {
  BluetoothSignal.weak: Icon(Icons.signal_cellular_alt_1_bar),
  BluetoothSignal.normal: Icon(Icons.signal_cellular_alt_2_bar),
  BluetoothSignal.good: Icon(Icons.signal_cellular_alt),
};

/// Only statuses exposed by the public compatibility package are mapped here.
const statusIcons = {
  PrinterStatus.good: Icon(Icons.check_circle_outline, color: Colors.green),
  PrinterStatus.writeFailed: Icon(Icons.error_outline, color: Colors.red),
  PrinterStatus.paperNotFound: Icon(Icons.error_outline, color: Colors.red),
  PrinterStatus.lowBattery: Icon(Icons.warning_amber_outlined, color: Colors.orange),
  PrinterStatus.tooHot: Icon(Icons.warning_amber_outlined, color: Colors.orange),
  PrinterStatus.unknown: Icon(Icons.warning_amber_outlined, color: Colors.orange),
  PrinterStatus.printing: SizedBox.square(
    dimension: 16,
    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
  ),
};

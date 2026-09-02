import 'package:flutter/material.dart';
import 'package:possystem/models/printer.dart';
import 'package:possystem/services/bluetooth.dart';
import 'package:possystem/translator.dart';

class PrinterInfoDialog extends StatelessWidget {
  final Printer printer;
  final BluetoothSignal? signal;
  final PrinterStatus? status;

  const PrinterInfoDialog({super.key, required this.printer, this.signal, this.status});

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
          if (signal != null) ...[
            const SizedBox(height: 8),
            Row(children: [signalIcons[signal] ?? const Icon(Icons.bluetooth), const SizedBox(width: 8), const Text('سیگنال')]),
          ],
          if (status != null) ...[
            const SizedBox(height: 8),
            Row(children: [statusIcons[status] ?? const Icon(Icons.info_outline), const SizedBox(width: 8), const Text('وضعیت چاپگر')]),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
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

const statusIcons = {
  PrinterStatus.good: Icon(Icons.check_circle_outline, color: Colors.green),
  PrinterStatus.writeFailed: Icon(Icons.error_outline, color: Colors.red),
  PrinterStatus.paperNotFound: Icon(Icons.error_outline, color: Colors.red),
  PrinterStatus.lowBattery: Icon(Icons.warning_amber_outlined, color: Colors.orange),
  PrinterStatus.tooHot: Icon(Icons.warning_amber_outlined, color: Colors.orange),
  PrinterStatus.unknown: Icon(Icons.warning_amber_outlined, color: Colors.orange),
  PrinterStatus.printing: SizedBox.square(dimension: 16, child: CircularProgressIndicator.adaptive(strokeWidth: 2)),
};

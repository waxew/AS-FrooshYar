import 'package:flutter/material.dart';
import 'package:possystem/models/printer.dart';
import 'package:possystem/ui/printer/widgets/printer_info_dialog.dart';

/// Printer quick access button.
class PrinterButtonView extends StatelessWidget {
  const PrinterButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    final printers = Printers.instance.items;

    return IconButton(
      icon: Icon(
        printers.any((item) => item.connected)
            ? Icons.print_outlined
            : Icons.print_disabled_outlined,
      ),
      onPressed: () async {
        if (printers.isEmpty) return;

        await showDialog(
          context: context,
          builder: (_) => PrinterInfoDialog(
            printer: printers.first,
          ),
        );
      },
    );
  }
}

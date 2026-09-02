import 'package:flutter/material.dart';

/// Invoice history screen.
class InvoicesListPage extends StatelessWidget {
  const InvoicesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('فاکتورها')),
        body: const Center(
          child: Text('لیست فاکتورهای فروشیار'),
        ),
      ),
    );
  }
}

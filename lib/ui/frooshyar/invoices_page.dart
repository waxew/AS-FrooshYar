import 'package:flutter/material.dart';

/// Invoice management screen foundation.
///
/// Future versions will connect this page to invoice repository, PDF export
/// and printer services.
class FrooshyarInvoicesPage extends StatelessWidget {
  const FrooshyarInvoicesPage({super.key});

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

import 'package:flutter/material.dart';

/// Invoice detail screen.
class InvoiceDetailPage extends StatelessWidget {
  const InvoiceDetailPage({super.key, this.invoiceNumber = 'FR-1405-000001'});

  final String invoiceNumber;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('فاکتور $invoiceNumber')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Text('اطلاعات مشتری'),
            Divider(),
            Text('اقلام فاکتور'),
            Divider(),
            Text('مبلغ کل'),
            Text('پرداخت شده'),
            Text('مانده'),
          ],
        ),
      ),
    );
  }
}

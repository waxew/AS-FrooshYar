import 'package:flutter/material.dart';

/// Customer financial account overview.
class CustomerAccountPage extends StatelessWidget {
  const CustomerAccountPage({super.key, this.customerName = 'مشتری'});

  final String customerName;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('حساب $customerName')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Card(child: ListTile(title: Text('مجموع خرید'), trailing: Text('۰ تومان'))),
            Card(child: ListTile(title: Text('مجموع پرداخت'), trailing: Text('۰ تومان'))),
            Card(child: ListTile(title: Text('مانده حساب'), trailing: Text('۰ تومان'))),
            SizedBox(height: 16),
            Text('سابقه فاکتورها'),
            Text('سابقه پرداخت‌ها'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Sales checkout screen.
///
/// This is the first user-facing flow for the FrooshYar sales process.
/// Business logic remains in services and repositories.
class SalesCheckoutPage extends StatelessWidget {
  const SalesCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ثبت فروش'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('انتخاب مشتری'),
            ),
            ListTile(
              leading: Icon(Icons.inventory_2_outlined),
              title: Text('انتخاب کالا'),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart_outlined),
              title: Text('سبد فروش'),
            ),
            ListTile(
              leading: Icon(Icons.payment_outlined),
              title: Text('پرداخت'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('صدور فاکتور'),
          icon: Icon(Icons.receipt_long),
        ),
      ),
    );
  }
}

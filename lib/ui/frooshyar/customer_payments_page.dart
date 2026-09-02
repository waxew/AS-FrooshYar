import 'package:flutter/material.dart';

/// Payment history screen for a customer.
class CustomerPaymentsPage extends StatelessWidget {
  const CustomerPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('پرداخت‌های مشتری')),
        body: const Center(
          child: Text('لیست پرداخت‌ها'),
        ),
      ),
    );
  }
}

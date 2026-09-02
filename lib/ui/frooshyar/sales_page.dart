import 'package:flutter/material.dart';

/// Main sales entry screen for FrooshYar.
class FrooshyarSalesPage extends StatelessWidget {
  const FrooshyarSalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('ثبت فروش')),
        body: const Center(
          child: Text('ثبت فروش جدید'),
        ),
      ),
    );
  }
}

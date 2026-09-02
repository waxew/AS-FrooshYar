import 'package:flutter/material.dart';

/// Main business dashboard for FrooshYar.
class FrooshyarDashboardPage extends StatelessWidget {
  const FrooshyarDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      ('فروش امروز', Icons.point_of_sale_outlined),
      ('تعداد فاکتورها', Icons.receipt_long_outlined),
      ('موجودی کم', Icons.warning_amber_outlined),
      ('مشتریان اخیر', Icons.people_outline),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('داشبورد فروشیار')),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cards[index].$2, size: 32),
                  const SizedBox(height: 12),
                  Text(cards[index].$1),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

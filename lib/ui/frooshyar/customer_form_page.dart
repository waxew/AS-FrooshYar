import 'package:flutter/material.dart';

/// Customer create/edit form base.
class CustomerFormPage extends StatelessWidget {
  const CustomerFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('افزودن مشتری')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              TextField(decoration: InputDecoration(labelText: 'نام مشتری')),
              TextField(decoration: InputDecoration(labelText: 'شماره تماس')),
              TextField(decoration: InputDecoration(labelText: 'آدرس')),
              TextField(decoration: InputDecoration(labelText: 'توضیحات')),
            ],
          ),
        ),
      ),
    );
  }
}

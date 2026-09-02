import 'package:flutter/material.dart';

/// Product create/edit form base.
class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('افزودن کالا')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              TextField(decoration: InputDecoration(labelText: 'نام کالا')),
              TextField(decoration: InputDecoration(labelText: 'قیمت')),
              TextField(decoration: InputDecoration(labelText: 'موجودی')),
              TextField(decoration: InputDecoration(labelText: 'دسته‌بندی')),
            ],
          ),
        ),
      ),
    );
  }
}

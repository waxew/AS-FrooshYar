import 'package:flutter/material.dart';

/// Customer management base page.
///
/// Storage integration will connect to the offline database repository in the
/// next layer. This keeps UI and data logic separated.
class FrooshyarCustomersPage extends StatelessWidget {
  const FrooshyarCustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مشتریان')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.person_add),
        ),
        body: const Center(
          child: Text('لیست مشتریان فروشیار'),
        ),
      ),
    );
  }
}

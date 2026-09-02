import '../services/frooshyar_sales_service.dart';

/// Handles sales checkout actions from UI.
class SalesController {
  final FrooshyarSalesService service;

  SalesController(this.service);

  Future<int> checkout({
    int? customerId,
    required int total,
    required int paid,
    required List<Map<String, dynamic>> items,
  }) {
    return service.checkout(
      customerId: customerId,
      total: total,
      paid: paid,
      items: items,
    );
  }
}

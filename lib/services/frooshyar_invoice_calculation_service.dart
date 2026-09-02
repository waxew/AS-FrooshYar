import '../models/frooshyar_invoice_discount.dart';

/// Calculates invoice totals.
class FrooshyarInvoiceCalculationService {
  int calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) {
      final quantity = (item['quantity'] as num?)?.toDouble() ?? 0;
      final price = (item['price'] as num?)?.toInt() ?? 0;
      return sum + (quantity * price).round();
    });
  }

  int applyDiscount(int total, FrooshyarInvoiceDiscount discount) {
    return discount.apply(total);
  }
}

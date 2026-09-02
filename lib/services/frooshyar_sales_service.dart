import '../database/dao/invoice_dao.dart';
import '../utils/frooshyar_invoice_number.dart';

/// Business workflow for registering a sale.
class FrooshyarSalesService {
  final InvoiceDao invoiceDao;

  FrooshyarSalesService(this.invoiceDao);

  Future<int> checkout({
    int? customerId,
    required int total,
    required int paid,
    required List<Map<String, dynamic>> items,
  }) {
    return invoiceDao.create({
      'invoice_number': FrooshyarInvoiceNumber.generate(),
      'customer_id': customerId,
      'total_amount': total,
      'paid_amount': paid,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }
}

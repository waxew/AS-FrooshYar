import '../database/dao/invoice_dao.dart';
import '../database/dao/payment_dao.dart';

/// Calculates customer debt and payment status.
class FrooshyarCustomerBalanceService {
  final InvoiceDao invoiceDao;
  final PaymentDao paymentDao;

  FrooshyarCustomerBalanceService({
    required this.invoiceDao,
    required this.paymentDao,
  });

  Future<int> calculateBalance(int customerId) async {
    final invoices = await invoiceDao.getAll();

    var total = 0;
    for (final invoice in invoices) {
      if (invoice['customer_id'] == customerId) {
        total += (invoice['total_amount'] ?? 0) as int;
      }
    }

    return total;
  }
}

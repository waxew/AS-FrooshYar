import '../database/dao/invoice_dao.dart';
import '../database/dao/payment_dao.dart';

/// Calculates customer purchases, payments and outstanding balance.
class FrooshyarCustomerBalanceService {
  final InvoiceDao invoiceDao;
  final PaymentDao paymentDao;

  FrooshyarCustomerBalanceService({
    required this.invoiceDao,
    required this.paymentDao,
  });

  /// Returns a stable summary consumed by the customer account controller.
  Future<Map<String, dynamic>> getCustomerBalance(int customerId) async {
    final invoices = await invoiceDao.getByCustomer(customerId);
    final payments = await paymentDao.getByCustomer(customerId);

    final totalPurchase = invoices.fold<double>(
      0,
      (sum, invoice) => sum + ((invoice['total_amount'] as num?)?.toDouble() ?? 0),
    );
    final totalPayment = payments.fold<double>(
      0,
      (sum, payment) => sum + ((payment['amount'] as num?)?.toDouble() ?? 0),
    );

    return {
      'totalPurchase': totalPurchase,
      'totalPayment': totalPayment,
      'balance': totalPurchase - totalPayment,
    };
  }

  Future<int> calculateBalance(int customerId) async {
    final summary = await getCustomerBalance(customerId);
    return (summary['balance'] as num).round();
  }
}

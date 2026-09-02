import '../database/dao/invoice_dao.dart';
import '../database/dao/stock_dao.dart';
import '../utils/frooshyar_invoice_number.dart';

/// Business workflow for registering a sale.
class FrooshyarSalesService {
  final InvoiceDao invoiceDao;
  final StockDao stockDao;

  FrooshyarSalesService({
    required this.invoiceDao,
    required this.stockDao,
  });

  Future<int> checkout({
    int? customerId,
    required int total,
    required int paid,
    required List<Map<String, dynamic>> items,
  }) async {
    // The next local id is used only for a readable offline invoice number.
    final existing = await invoiceDao.getAll();
    final nextId = existing.isEmpty
        ? 1
        : ((existing.first['id'] as num?)?.toInt() ?? 0) + 1;

    final invoiceId = await invoiceDao.createInvoice(
      invoiceNumber: FrooshyarInvoiceNumber.generate(nextId),
      customerId: customerId,
      totalAmount: total,
      paidAmount: paid,
      items: items,
    );

    for (final item in items) {
      await stockDao.decreaseStock(
        item['product_id'] as int,
        (item['quantity'] as num).toDouble(),
      );
    }

    return invoiceId;
  }
}

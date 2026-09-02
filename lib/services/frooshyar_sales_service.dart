import '../database/dao/invoice_dao.dart';
import '../database/dao/stock_dao.dart';
import '../utils/frooshyar_invoice_number.dart';

/// Business workflow for registering a sale.
///
/// Invoice, line items, payment and stock changes are committed in one SQLite
/// transaction so a failed checkout never leaves partially-written data.
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
    String paymentMethod = 'cash',
    String? paymentNote,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('A sale must contain at least one item.');
    }
    if (total < 0 || paid < 0 || paid > total) {
      throw ArgumentError('Invalid sale totals.');
    }

    final db = await invoiceDao.helper.database;
    return db.transaction((txn) async {
      final idRows = await txn.rawQuery('SELECT MAX(id) AS max_id FROM invoices');
      final lastId = (idRows.first['max_id'] as num?)?.toInt() ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      final invoiceId = await txn.insert('invoices', {
        'invoice_number': FrooshyarInvoiceNumber.generate(lastId + 1),
        'customer_id': customerId,
        'total_amount': total,
        'paid_amount': paid,
        'created_at': now,
      });

      for (final source in items) {
        final productId = (source['product_id'] as num?)?.toInt();
        final quantity = (source['quantity'] as num?)?.toDouble() ?? 0;
        final price = (source['price'] as num?)?.toInt() ?? 0;

        if (productId == null || quantity <= 0 || price < 0) {
          throw ArgumentError('Invalid sale item.');
        }

        final changed = await txn.rawUpdate(
          'UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?',
          [quantity, productId, quantity],
        );
        if (changed != 1) {
          throw StateError('Insufficient stock for product $productId.');
        }

        await txn.insert('invoice_items', {
          'invoice_id': invoiceId,
          'product_id': productId,
          'quantity': quantity,
          'price': price,
        });
      }

      if (paid > 0) {
        await txn.insert('payments', {
          'invoice_id': invoiceId,
          'customer_id': customerId,
          'amount': paid,
          'method': paymentMethod,
          'note': paymentNote,
          'created_at': now,
        });
      }

      return invoiceId;
    });
  }
}

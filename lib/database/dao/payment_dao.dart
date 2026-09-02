import '../sqlite/frooshyar_sqlite_helper.dart';

/// Payment transaction access layer.
class PaymentDao {
  final FrooshyarSqliteHelper helper;

  PaymentDao(this.helper);

  Future<int> addPayment(Map<String, dynamic> payment) async {
    final db = await helper.database;
    final amount = (payment['amount'] as num?)?.toDouble() ?? 0;
    if (amount <= 0) {
      throw ArgumentError('Payment amount must be positive.');
    }
    return db.insert('payments', payment);
  }

  Future<List<Map<String, dynamic>>> getByInvoice(int invoiceId) async {
    final db = await helper.database;
    return db.query(
      'payments',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getByCustomer(int customerId) async {
    final db = await helper.database;
    return db.query(
      'payments',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'created_at DESC',
    );
  }
}

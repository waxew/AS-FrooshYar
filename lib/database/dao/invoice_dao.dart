import '../sqlite/frooshyar_sqlite_helper.dart';

/// Invoice and sales transaction data access layer.
class InvoiceDao {
  final FrooshyarSqliteHelper helper;

  InvoiceDao(this.helper);

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await helper.database;
    return db.query('invoices', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> getByCustomer(int customerId) async {
    final db = await helper.database;
    return db.query(
      'invoices',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> create(Map<String, dynamic> invoice) async {
    final db = await helper.database;
    return db.insert('invoices', invoice);
  }

  /// Stores the invoice header and all line items atomically.
  Future<int> createInvoice({
    required String invoiceNumber,
    int? customerId,
    required int totalAmount,
    required int paidAmount,
    required List<Map<String, dynamic>> items,
  }) async {
    final db = await helper.database;
    return db.transaction((txn) async {
      final invoiceId = await txn.insert('invoices', {
        'invoice_number': invoiceNumber,
        'customer_id': customerId,
        'total_amount': totalAmount,
        'paid_amount': paidAmount,
        'created_at': DateTime.now().toIso8601String(),
      });
      for (final source in items) {
        final item = Map<String, dynamic>.from(source);
        item['invoice_id'] = invoiceId;
        await txn.insert('invoice_items', item);
      }
      return invoiceId;
    });
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    final db = await helper.database;
    await db.insert('invoice_items', item);
  }

  Future<void> delete(int id) async {
    final db = await helper.database;
    await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }
}

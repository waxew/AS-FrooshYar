import 'package:sqflite/sqflite.dart';
import '../sqlite/frooshyar_sqlite_helper.dart';

/// Payment transaction access layer.
class PaymentDao {
  final FrooshyarSqliteHelper helper;

  PaymentDao(this.helper);

  Future<int> addPayment(Map<String, dynamic> payment) async {
    final Database db = await helper.database;
    return db.insert('payments', payment);
  }

  Future<List<Map<String, dynamic>>> getByInvoice(int invoiceId) async {
    final Database db = await helper.database;
    return db.query(
      'payments',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );
  }
}

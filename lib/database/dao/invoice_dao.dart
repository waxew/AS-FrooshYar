import 'package:sqflite/sqflite.dart';
import '../sqlite/frooshyar_sqlite_helper.dart';

/// Invoice and sales transaction data access layer.
///
/// Invoice creation uses a database transaction so invoice header and items are
/// stored together.
class InvoiceDao {
  final FrooshyarSqliteHelper helper;

  InvoiceDao(this.helper);

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await helper.database;
    return db.query('invoices', orderBy: 'id DESC');
  }

  Future<int> create(Map<String, dynamic> invoice) async {
    final db = await helper.database;

    return db.transaction((txn) async {
      return txn.insert('invoices', invoice);
    });
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    final db = await helper.database;
    await db.insert('invoice_items', item);
  }

  Future<void> delete(int id) async {
    final db = await helper.database;
    await db.delete(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

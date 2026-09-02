import 'package:sqflite/sqflite.dart';
import '../database/sqlite/frooshyar_sqlite_helper.dart';

/// Loads complete invoice information.
class FrooshyarInvoiceDetailService {
  final FrooshyarSqliteHelper helper;

  FrooshyarInvoiceDetailService(this.helper);

  Future<Map<String, dynamic>> getInvoiceDetail(int invoiceId) async {
    final Database db = await helper.database;

    final invoice = await db.query(
      'invoices',
      where: 'id = ?',
      whereArgs: [invoiceId],
    );

    final items = await db.query(
      'invoice_items',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );

    final payments = await db.query(
      'payments',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );

    return {
      'invoice': invoice,
      'items': items,
      'payments': payments,
    };
  }
}

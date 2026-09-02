import '../database/sqlite/frooshyar_sqlite_helper.dart';

/// Provides lightweight dashboard statistics for FrooshYar.
class FrooshyarDashboardService {
  final FrooshyarSqliteHelper helper;

  FrooshyarDashboardService(this.helper);

  /// Returns the values consumed by the dashboard controller in one call.
  Future<Map<String, num>> getSummary() async {
    return {
      'todaySales': await todaySales(),
      'invoiceCount': await invoiceCount(),
      'lowStockCount': await lowStockCount(),
    };
  }

  Future<int> todaySales() async {
    final db = await helper.database;
    final start = DateTime.now();
    final day = DateTime(start.year, start.month, start.day).toIso8601String();
    final rows = await db.rawQuery(
      'SELECT COALESCE(SUM(total_amount), 0) AS total FROM invoices WHERE created_at >= ?',
      [day],
    );
    return ((rows.first['total'] as num?) ?? 0).round();
  }

  Future<int> invoiceCount() async {
    final db = await helper.database;
    final rows = await db.rawQuery('SELECT COUNT(*) AS total FROM invoices');
    return ((rows.first['total'] as num?) ?? 0).toInt();
  }

  Future<int> lowStockCount() async {
    final db = await helper.database;
    final rows = await db.rawQuery('SELECT COUNT(*) AS total FROM products WHERE stock <= 5');
    return ((rows.first['total'] as num?) ?? 0).toInt();
  }
}

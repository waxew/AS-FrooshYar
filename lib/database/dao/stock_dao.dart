import 'package:sqflite/sqflite.dart';
import '../sqlite/frooshyar_sqlite_helper.dart';

/// Inventory data access layer.
class StockDao {
  final FrooshyarSqliteHelper helper;

  StockDao(this.helper);

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await helper.database;
    return db.query('products', orderBy: 'id DESC');
  }

  Future<void> decreaseStock(int productId, double amount) async {
    final db = await helper.database;

    await db.rawUpdate(
      'UPDATE products SET stock = stock - ? WHERE id = ?',
      [amount, productId],
    );
  }
}

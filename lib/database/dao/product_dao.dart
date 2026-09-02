import '../frooshyar_repository.dart';
import '../sqlite/frooshyar_sqlite_helper.dart';

/// Product and inventory CRUD operations.
class ProductDao {
  final FrooshyarRepository repository;

  ProductDao(this.repository);

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await FrooshyarSqliteHelper.instance.database;
    return db.query('products', orderBy: 'id DESC');
  }

  Future<int> insert(Map<String, dynamic> product) async {
    final db = await FrooshyarSqliteHelper.instance.database;
    return db.insert('products', product);
  }

  Future<int> update(Map<String, dynamic> product) async {
    final db = await FrooshyarSqliteHelper.instance.database;
    return db.update('products', product, where: 'id = ?', whereArgs: [product['id']]);
  }

  Future<int> delete(int id) async {
    final db = await FrooshyarSqliteHelper.instance.database;
    return db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}

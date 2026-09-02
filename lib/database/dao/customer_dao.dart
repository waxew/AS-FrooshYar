import '../frooshyar_repository.dart';
import '../sqlite/frooshyar_sqlite_helper.dart';

/// Customer CRUD operations.
class CustomerDao {
  final FrooshyarRepository repository;

  CustomerDao(this.repository);

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await FrooshyarSqliteHelper.instance.database;
    return db.query('customers', orderBy: 'id DESC');
  }

  Future<int> insert(Map<String, dynamic> customer) async {
    final db = await FrooshyarSqliteHelper.instance.database;
    return db.insert('customers', customer);
  }

  Future<int> update(Map<String, dynamic> customer) async {
    final db = await FrooshyarSqliteHelper.instance.database;
    return db.update(
      'customers',
      customer,
      where: 'id = ?',
      whereArgs: [customer['id']],
    );
  }

  Future<int> delete(int id) async {
    final db = await FrooshyarSqliteHelper.instance.database;
    return db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }
}

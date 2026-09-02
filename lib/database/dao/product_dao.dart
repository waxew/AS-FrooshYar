import '../frooshyar_repository.dart';

/// Product and inventory data access layer.
class ProductDao {
  final FrooshyarRepository repository;

  ProductDao(this.repository);

  Future<List<Map<String, dynamic>>> getAll() async {
    return [];
  }

  Future<int> insert(Map<String, dynamic> product) async {
    return 0;
  }

  Future<void> update(Map<String, dynamic> product) async {}

  Future<void> delete(int id) async {}
}

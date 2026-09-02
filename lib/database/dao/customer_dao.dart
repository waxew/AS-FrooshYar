import '../frooshyar_repository.dart';

/// Customer data access layer.
///
/// All customer operations will go through this class to keep database logic
/// separated from screens.
class CustomerDao {
  final FrooshyarRepository repository;

  CustomerDao(this.repository);

  Future<List<Map<String, dynamic>>> getAll() async {
    return [];
  }

  Future<int> insert(Map<String, dynamic> customer) async {
    return 0;
  }

  Future<void> update(Map<String, dynamic> customer) async {}

  Future<void> delete(int id) async {}
}

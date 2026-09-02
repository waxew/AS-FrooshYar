import '../frooshyar_repository.dart';

/// Invoice and sales transaction data access layer.
class InvoiceDao {
  final FrooshyarRepository repository;

  InvoiceDao(this.repository);

  Future<List<Map<String, dynamic>>> getAll() async {
    return [];
  }

  Future<int> create(Map<String, dynamic> invoice) async {
    return 0;
  }

  Future<void> addItem(Map<String, dynamic> item) async {}

  Future<void> delete(int id) async {}
}

import '../database/dao/product_dao.dart';

/// Product and inventory controller.
class ProductController {
  final ProductDao dao;

  ProductController(this.dao);

  Future<List<Map<String, dynamic>>> loadProducts() {
    return dao.getAll();
  }

  Future<int> saveProduct(Map<String, dynamic> data) {
    return dao.insert(data);
  }

  Future<void> removeProduct(int id) {
    return dao.delete(id);
  }
}

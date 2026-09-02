import '../database/dao/customer_dao.dart';

/// Connects customer UI actions with the data layer.
class CustomerController {
  final CustomerDao dao;

  CustomerController(this.dao);

  Future<List<Map<String, dynamic>>> loadCustomers() {
    return dao.getAll();
  }

  Future<int> saveCustomer(Map<String, dynamic> data) {
    return dao.insert(data);
  }

  Future<void> removeCustomer(int id) {
    return dao.delete(id);
  }
}

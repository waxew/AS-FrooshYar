import '../services/frooshyar_customer_balance_service.dart';

/// Controller for customer financial information.
class CustomerAccountController {
  final FrooshyarCustomerBalanceService service;

  CustomerAccountController(this.service);

  Future<Map<String, dynamic>> loadBalance(int customerId) {
    return service.getCustomerBalance(customerId);
  }
}

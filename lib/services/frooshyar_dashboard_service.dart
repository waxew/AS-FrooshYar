import '../database/sqlite/frooshyar_sqlite_helper.dart';

/// Provides dashboard statistics for FrooshYar.
class FrooshyarDashboardService {
  final FrooshyarSqliteHelper helper;

  FrooshyarDashboardService(this.helper);

  Future<int> todaySales() async {
    // Aggregation query will be added with the final report layer.
    return 0;
  }

  Future<int> invoiceCount() async {
    return 0;
  }

  Future<int> lowStockCount() async {
    return 0;
  }
}

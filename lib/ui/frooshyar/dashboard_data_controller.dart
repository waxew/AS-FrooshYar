import '../services/frooshyar_dashboard_service.dart';

/// Provides dashboard metrics to the UI layer.
class DashboardDataController {
  final FrooshyarDashboardService service;

  DashboardDataController(this.service);

  Future<Map<String, dynamic>> loadSummary() {
    return service.getSummary();
  }
}

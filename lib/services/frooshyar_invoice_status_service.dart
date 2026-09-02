/// Determines invoice payment state.
class FrooshyarInvoiceStatusService {
  String status({required int total, required int paid}) {
    if (paid >= total) return 'پرداخت کامل';
    if (paid > 0) return 'پرداخت ناقص';
    return 'نسیه';
  }
}

/// Invoice printing abstraction.
///
/// PDF and thermal printer implementations can be attached later without
/// changing invoice business logic.
class FrooshyarInvoicePrintService {
  Future<void> printInvoice(int invoiceId) async {
    // PDF and printer integration will be connected here.
  }
}

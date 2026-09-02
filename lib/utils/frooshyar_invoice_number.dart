/// Invoice number generator for FrooshYar.
///
/// The generated number remains simple for offline usage and can later be
/// synchronized with cloud numbering rules.
class FrooshyarInvoiceNumber {
  static String generate(int id) {
    final year = DateTime.now().year;
    return 'FR-$year-${id.toString().padLeft(6, '0')}';
  }
}

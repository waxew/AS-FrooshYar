/// Discount model for invoices.
class FrooshyarInvoiceDiscount {
  final int amount;
  final double percent;

  const FrooshyarInvoiceDiscount({
    this.amount = 0,
    this.percent = 0,
  });

  int apply(int total) {
    if (percent > 0) {
      return total - (total * percent / 100).round();
    }
    return total - amount;
  }
}

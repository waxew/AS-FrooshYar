/// Payment record model for FrooshYar invoices.
class FrooshyarPayment {
  final int? id;
  final int? invoiceId;
  final int amount;
  final String method;
  final int createdAt;

  const FrooshyarPayment({
    this.id,
    this.invoiceId,
    required this.amount,
    required this.method,
    required this.createdAt,
  });
}

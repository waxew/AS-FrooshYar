/// Offline invoice model for FrooshYar.
class FrooshYarInvoice {
  final String id;
  final String invoiceNumber;
  final String customerId;
  final int totalAmount;
  final int paidAmount;
  final DateTime createdAt;

  const FrooshYarInvoice({
    required this.id,
    required this.invoiceNumber,
    this.customerId = '',
    this.totalAmount = 0,
    this.paidAmount = 0,
    required this.createdAt,
  });

  int get remainingAmount => totalAmount - paidAmount;

  Map<String, dynamic> toMap() => {
        'id': id,
        'invoiceNumber': invoiceNumber,
        'customerId': customerId,
        'totalAmount': totalAmount,
        'paidAmount': paidAmount,
        'createdAt': createdAt.toIso8601String(),
      };
}

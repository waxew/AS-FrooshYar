/// Customer model for FrooshYar sales management.
///
/// This lightweight model is prepared for Room/SQLite migration in future
/// versions while keeping the offline-first architecture.
class FrooshYarCustomer {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String note;
  final DateTime createdAt;

  const FrooshYarCustomer({
    required this.id,
    required this.name,
    this.phone = '',
    this.address = '',
    this.note = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
        'address': address,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FrooshYarCustomer.fromMap(Map<String, dynamic> map) {
    return FrooshYarCustomer(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      note: map['note'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

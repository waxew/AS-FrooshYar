import 'package:intl/intl.dart';

/// Currency helpers for Iranian businesses.
class FrooshyarCurrency {
  static final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  static String format(num amount) {
    return '${_formatter.format(amount)} تومان';
  }
}

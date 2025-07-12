import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }

  static String formatDate(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  static String formatDateTime(
    DateTime dateTime, {
    String pattern = 'yyyy-MM-dd HH:mm',
  }) {
    final formatter = DateFormat(pattern);
    return formatter.format(dateTime);
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }

    return phoneNumber; // Return original if not 10 digits
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }
}

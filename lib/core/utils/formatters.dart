import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(num? amount) {
    if (amount == null || amount == 0) {
      return 'Gratis';
    }
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDate(dynamic dateTime) {
    if (dateTime == null) return '-';
    DateTime? dt;
    if (dateTime is DateTime) {
      dt = dateTime;
    } else if (dateTime is String && dateTime.isNotEmpty) {
      dt = DateTime.tryParse(dateTime);
    }
    if (dt == null) return dateTime.toString();
    return DateFormat('d MMM yyyy', 'id_ID').format(dt.toLocal());
  }

  static String formatDateTime(dynamic dateTime) {
    if (dateTime == null) return '-';
    DateTime? dt;
    if (dateTime is DateTime) {
      dt = dateTime;
    } else if (dateTime is String && dateTime.isNotEmpty) {
      dt = DateTime.tryParse(dateTime);
    }
    if (dt == null) return dateTime.toString();
    final formatted = DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dt.toLocal());
    return '$formatted WIB';
  }

  static String formatTime(dynamic dateTime) {
    if (dateTime == null) return '-';
    DateTime? dt;
    if (dateTime is DateTime) {
      dt = dateTime;
    } else if (dateTime is String && dateTime.isNotEmpty) {
      dt = DateTime.tryParse(dateTime);
    }
    if (dt == null) return dateTime.toString();
    final formatted = DateFormat('HH:mm', 'id_ID').format(dt.toLocal());
    return '$formatted WIB';
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }
}

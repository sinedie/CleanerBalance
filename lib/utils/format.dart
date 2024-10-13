import 'package:intl/intl.dart';

final currencyFormat = NumberFormat("\$ #,##0.00", "en_US");

String formatAsCurrency(dynamic amount, String currency) {
  return "${currencyFormat.format(amount)} $currency";
}

String parseDate(DateTime date) {
  return date.toIso8601String().split("T")[0];
}

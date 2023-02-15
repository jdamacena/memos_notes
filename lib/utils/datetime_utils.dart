import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat("MMM dd, yyyy 'at' HH:mm");
    final String formatted = formatter.format(dateTime);

    return formatted;
  }
}

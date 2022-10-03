import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateHandler {
  String myDate(int timestamp) {
    String local = "fr_FR";
    initializeDateFormatting(local, null);
    DateTime postDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    DateFormat format;
    if (now.difference(postDate).inDays > 0) {
      format = DateFormat.yMMMd(local);
    } else {
      format = DateFormat.Hm(local);
    }
    return format.format(postDate).toString();
  }
}

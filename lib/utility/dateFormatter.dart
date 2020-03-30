import 'package:intl/intl.dart';

class DateFormatter {
  ///Formats a single [transferDate] (yearmonthday) to readable Format (day.month.year)
  String formatDate(int transferDate) {
    var dateString = '$transferDate';
    var year = dateString.substring(0, 4);
    var month = dateString.substring(4, 6);
    var day = dateString.substring(6, dateString.length);
    return '$day.$month.$year';
  }

  ///Formats a [selectedDateRange] from the datepicker to a readable Range Format
  String formatDateRange(List<DateTime> selectedDateRange) {
    List<String> dateStrings = [];
    selectedDateRange.forEach((date) {
      var year = DateFormat('yyyy').format(date);
      var month = DateFormat('LLLL').format(date);
      dateStrings.add('$month $year');
    });
    return '$dateStrings';
  }

  ///Checks if today or yesterday is equal to [date]. Returns string if true.
  String getDayNameString(int date) {
    var dateString = '$date';
    DateTime now = DateTime.now();
    //If the length of a returned String is 1, add 0 in front to get the right format
    var dayToday = '${now.day}'.length == 1 ? '0${now.day}' : '${now.day}';
    var monthToday = '${now.month}'.length == 1 ? '0${now.month}' : '${now.month}';
    var yearToday = '${now.year}';
    var dayYesterday = '${now.subtract(Duration(days: 1)).day}'.length == 1
        ? '0${now.subtract(Duration(days: 1)).day}'
        : '${now.subtract(Duration(days: 1)).day}';
    var monthYesterday = '${now.subtract(Duration(days: 1)).month}'.length == 1
        ? '0${now.subtract(Duration(days: 1)).month}'
        : '${now.subtract(Duration(days: 1)).month}';
    var yearYesterday = '${now.subtract(Duration(days: 1)).year}';

    //Datecheck
    if (dateString == yearToday + monthToday + dayToday) {
      return 'Today';
    } else if (dateString == yearYesterday + monthYesterday + dayYesterday) {
      return 'Yesterday';
    } else {
      return formatDate(date);
    }
  }
}

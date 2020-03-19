class DateFormatter {
  ///Formats a single [date] (yearmonthday) to readable Format (day.month.year)
  String formatDate(int date) {
    var dateString = '$date';
    var year = dateString.substring(0, 4);
    var month = dateString.substring(4, 6);
    var day = dateString.substring(6, dateString.length);
    return '$day.$month.$year';
  }

  ///Formats a [selectedDateRange] from the datepicker to a readable Range Format
  String formatDateRange(List<String> selectedDateRange) {
    List<String> dateStrings = [];
    selectedDateRange.forEach((date) {
      var year = date.substring(0, 4);
      var month = date.substring(4, 6);
      var day = date.substring(6, date.length);
      dateStrings.add('$day.$month.$year');
    });
    return '${dateStrings[0]} - ${dateStrings[1]}';
  }

  ///Checks if today or yesterday is equal to [date]. Returns string if true.
  String getDayNameString(int date) {
    var dateString = '$date';

    //If the length of a returned String is 1, add 0 in front to get the right format
    var dayToday =
        '${DateTime.now().day}'.length == 1 ? '0${DateTime.now().day}' : '${DateTime.now().day}';
    var monthToday = '${DateTime.now().month}'.length == 1
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    var yearToday = '${DateTime.now().year}';
    var dayYesterday = '${DateTime.now().subtract(Duration(days: 1)).day}'.length == 1
        ? '0${DateTime.now().subtract(Duration(days: 1)).day}'
        : '${DateTime.now().subtract(Duration(days: 1)).day}';
    var monthYesterday = '${DateTime.now().subtract(Duration(days: 1)).month}'.length == 1
        ? '0${DateTime.now().subtract(Duration(days: 1)).month}'
        : '${DateTime.now().subtract(Duration(days: 1)).month}';
    var yearYesterday = '${DateTime.now().subtract(Duration(days: 1)).year}';

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

class DateFormatter {
  ///Formats a single [transferDate] (yearmonthday) to readable Format (day.month.year)
  String formatDate(int transferDate) {
    var dateString = '$transferDate';
    var year = dateString.substring(0, 4);
    var month = dateString.substring(4, 6);
    var day = dateString.substring(6, dateString.length);
    return '$day.$month.$year';
  }

  ///Takes in the [transferDate] and returns the week (1-5) for this date.
  String calculateWeek(int transferDate) {
    var dateString = '$transferDate';
    var day = int.parse(dateString.substring(6, dateString.length));
    if (day >= 1 && day <= 7) {
      return '1';
    } else if (day >= 8 && day <= 14) {
      return '2';
    } else if (day >= 15 && day <= 21) {
      return '3';
    } else if (day >= 22 && day <= 28) {
      return '4';
    } else {
      return '5';
    }
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

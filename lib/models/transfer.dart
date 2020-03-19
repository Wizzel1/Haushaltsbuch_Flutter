import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Transfer {
  Transfer(
      {@required this.isExpense,
      @required this.name,
      @required this.amount,
      @required this.isRecurring,
      @required this.category,
      @required this.date,
      this.recurringDay = '',
      this.recurringInterval = ''});

  final String name;
  final double amount;
  final bool isExpense;
  final bool isRecurring;
  final String category;
  final String recurringDay;
  final String recurringInterval;
  final int date;

  //TODO: Implement icongetter in databaseservice
  var categoryIconMap = CategoryIconMap().categoryIconMap;
  Icon get icon {
    var iconString = categoryIconMap[category];

    return Icon(
      MaterialCommunityIcons.getIconData(iconString),
      color: kTextColorHeading,
      size: 30,
    );
  }
}

class CategoryIconMap {
  //TODO: Automate synchronisation of this map
  Map<String, String> categoryIconMap = {
    'Payment': 'coin',
    'Food': 'food-variant',
  };
}

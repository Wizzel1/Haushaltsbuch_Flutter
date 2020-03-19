import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/components/customFilterChip.dart';
import 'package:flutter_haushaltsbuch/components/flchart.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';
import 'package:flutter_haushaltsbuch/services/database.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter_haushaltsbuch/models/user.dart';
import 'package:flutter_haushaltsbuch/utility/dateFormatter.dart';
import 'package:flutter_haushaltsbuch/components/pieceBarChart.dart';
import 'package:intl/intl.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<String> _selectedCategories = [];
  List<String> _selectedDateRange = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return FutureProvider<List<Transfer>>.value(
      value: DatabaseService(uid: user.uid)
          .getSelectedTransfersBy(categories: _selectedCategories, dateRange: _selectedDateRange),
      child: Scaffold(
        backgroundColor: kTextColorHeading,
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: kBackgroundColor,
                            ),
                            onPressed: () => Navigator.of(context).pop())
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: kTextColorHeading,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          height: 110,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kButtonRadius),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 3,
                                  children: _buildFilterChips(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
                        color: Colors.red,
                        onPressed: () async {
                          final List<DateTime> picked = await DateRangePicker.showDatePicker(
                              context: context,
                              initialFirstDate: _selectedDateRange.isEmpty
                                  ? DateTime.now()
                                  : DateTime.parse(_selectedDateRange[0]),
                              initialLastDate: _selectedDateRange.isEmpty
                                  ? (DateTime.now()).add(Duration(days: 7))
                                  : DateTime.parse(_selectedDateRange[1]),
                              firstDate: DateTime(2015),
                              lastDate: DateTime(2050));
                          if (picked != null && picked.length == 2) {
                            _handlePicked(picked);
                          }
                        },
                        child: Text(
                          _selectedDateRange.isEmpty
                              ? 'Select a period'
                              : DateFormatter().formatDateRange(_selectedDateRange),
                          style: kTabbarTextStyle.copyWith(color: kBackgroundColor),
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19),
                      topRight: Radius.circular(19),
                    ),
                  ),
                  child: Consumer<List<Transfer>>(
                    builder: (context, providerTransferData, child) {
                      return BarChartSample5();
                      StatisticBarChart(
                        providerData: providerTransferData,
                        dateRange: _selectedDateRange,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFilterChips() {
    Map categoryMap = CategoryIconMap().categoryIconMap;
    return categoryMap.entries
        .map((e) => CustomFilterChip(
              chipLabel: e.key,
              onSetActive: () {
                setState(() {
                  _selectedCategories.add(e.key);
                });
              },
              onSetInactive: () {
                setState(() {
                  _selectedCategories.remove(e.key);
                });
              },
            ))
        .toList();
  }

  void _handlePicked(List<DateTime> pickedDates) {
    String date1 = DateFormat('yyyyMMdd').format(pickedDates[0]);
    String date2 = DateFormat('yyyyMMdd').format(pickedDates[1]);
    List<String> dateRange = [date1, date2];
    setState(() {
      _selectedDateRange = dateRange;
    });
  }
}

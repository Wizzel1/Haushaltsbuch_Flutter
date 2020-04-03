import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/components/customFilterChip.dart';
import 'package:flutter_haushaltsbuch/components/flchart.dart';
import 'package:flutter_haushaltsbuch/components/monthPicker.dart';
import 'package:flutter_haushaltsbuch/components/pieChartIndicator.dart';
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
import 'package:flutter_haushaltsbuch/components/statisticsPieChart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<String> _selectedCategories = [];
  List<DateTime> _selectedDates = [];
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _selectedDates.isEmpty ? _selectedDates.add(DateTime.now()) : null;
    return FutureBuilder(
      future: DatabaseService(uid: user.uid).getDataBySelectedTime(
          categories: _selectedCategories, dateList: _selectedDates, dateRange: []),
      builder: (BuildContext context, AsyncSnapshot builderSnapshot) {
        return Scaffold(
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
//                      Container(
//                        width: MediaQuery.of(context).size.width,
//                        color: kTextColorHeading,
//                        child: Padding(
//                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                          child: Container(
//                            height: 110,
//                            width: double.infinity,
//                            decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(kButtonRadius),
//                              color: Colors.black.withOpacity(0.2),
//                            ),
//                            child: Padding(
//                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Wrap(
//                                    spacing: 10,
//                                    runSpacing: 3,
//                                    children: _buildFilterChips(),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            child: Text('clear'),
                            onPressed: () {
                              setState(() {
                                _selectedDates.removeRange(1, _selectedDates.length);
                                _selectedDates[0] = DateTime.now();
                              });
                            },
                          ),
                          RaisedButton(
                              elevation: 5,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
                              color: Colors.red,
                              onPressed: () async {
                                final DateTime picked = await showMonthPicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2050));
                                if (picked != null) {
                                  setState(() {
                                    _selectedDates[0] = picked;
                                  });
                                }
                              },
                              child: Text(
                                'test',
                                style: kTabbarTextStyle.copyWith(color: kBackgroundColor),
                              )),
                          FlatButton(
                            child: Text('add'),
                            onPressed: () async {
                              final DateTime picked = await showMonthPicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime(2050));
                              if (picked != null) {
                                setState(() {
                                  _selectedDates.add(picked);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Text(DateFormatter().formatDateRange(_selectedDates),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
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
                      child: _buildStatisticWidget(builderSnapshot)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticWidget(AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        //TODO: Edit placing of spinner
        return SpinKitPulse(
          color: kTextColorHeading,
          size: 50,
        );
      default:
        if (snapshot.hasError) {
          return Text('haserror');
        } else {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _selectedDates != null
                ? _selectedDates.length == 1
                    ? StatisticsPieChart(
                        data: snapshot.data,
                        touchedIndex: touchedIndex,
                      )
                    : StatisticsPieceBarChart(
                        data: snapshot.data,
                      )
                : Container(),
          );
        }
    }
  }

//  List<Widget> _buildFilterChips() {
//    Map categoryMap = CategoryIconMap().categoryIconMap;
//    return categoryMap.entries
//        .map((e) => CustomFilterChip(
//              chipLabel: e.key,
//              onSetActive: () {
//                setState(() {
//                  _selectedCategories.add(e.key);
//                });
//              },
//              onSetInactive: () {
//                setState(() {
//                  _selectedCategories.remove(e.key);
//                });
//              },
//            ))
//        .toList();
//  }

//  List<Widget> _buildIndicatorRow(AsyncSnapshot snapshot) {
//    if (!snapshot.hasError) {
//      var snapshotData = snapshot.data;
//      if (snapshotData.runtimeType == Map<String, dynamic>().runtimeType) {
//        //if the datatype of the asyncsnapshot is a single Map
//        Map<String, dynamic> dataMap = snapshotData;
//        List<MapEntry> entryList = dataMap.entries.toList();
//        return entryList.map((e) {
//          int index = entryList.indexOf(e);
//          return Indicator(
//            color: widget.colorList[index],
//            text: e.key,
//            onTap: () {
//              setState(() {
//                touchedIndex == index ? touchedIndex = -1 : touchedIndex = index;
//              });
//            },
//            isSquare: false,
//            size: touchedIndex == index ? 18 : 16,
//            textColor: touchedIndex == index ? Colors.black : Colors.grey,
//          );
//        }).toList();
//      } else if (snapshotData.runtimeType == List<Map<dynamic, dynamic>>().runtimeType) {
//        //if the datatype of the asyncsnapshot is a List of maps
//
//      }
//      //snapshot is either a single map or a list of maps
////      return Indicator(
////        color: widget.colorList[index],
////        text: e.key,
////        onTap: () {
////          setState(() {
////            touchedIndex == index ? touchedIndex = -1 : touchedIndex = index;
////          });
////        },
////        isSquare: false,
////        size: touchedIndex == index ? 18 : 16,
////        textColor: touchedIndex == index ? Colors.black : Colors.grey,
////      );
//      return [];
//    }
//  }

//TODO: Refactor this code for a detailed Range picker
//                          final List<DateTime> picked = await DateRangePicker.showDatePicker(
//                              context: context,
//                              initialFirstDate: _selectedDateRange.isEmpty
//                                  ? DateTime.now()
//                                  : _selectedDateRange[0],
//                              initialLastDate: _selectedDateRange.isEmpty
//                                  ? (DateTime.now()).add(Duration(days: 7))
//                                  : _selectedDateRange[1],
//                              firstDate: DateTime(2015),
//                              lastDate: DateTime(2050));
}

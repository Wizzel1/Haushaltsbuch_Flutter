import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';
import 'package:flutter_haushaltsbuch/components/pieChartIndicator.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';

class StatisticsPieceBarChart extends StatefulWidget {
  StatisticsPieceBarChart({this.data});

  final List<Map<dynamic, dynamic>> data;

  @override
  State<StatefulWidget> createState() => StatisticsPieceBarChartState();
}

class StatisticsPieceBarChartState extends State<StatisticsPieceBarChart> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  static const double barWidth = 30;

  List<int> _touchedIndex = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildIndicators()),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    maxY: 20,
                    groupsSpace: 12,
                    barTouchData: const BarTouchData(
                      enabled: false,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        textStyle: const TextStyle(color: Colors.black, fontSize: 12),
                        margin: 10,
                        rotateAngle: 0,
                        getTitles: (double value) {
                          switch (value.toInt()) {
                            case 0:
                              return 'Mon';
                            case 1:
                              return 'Tue';
                            case 2:
                              return 'Wed';
                            case 3:
                              return 'Thu';
                            case 4:
                              return 'Fri';
                            case 5:
                              return 'Sat';
                            case 6:
                              return 'Sun';
                            default:
                              return '';
                          }
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        textStyle: const TextStyle(color: Colors.black, fontSize: 15),
                        rotateAngle: 0,
                        getTitles: (double value) {
                          if (value == 0) {
                            return '';
                          }
                          return '${value.toInt()}0k';
                        },
                        interval: 5,
                        margin: 8,
                        reservedSize: 30,
                      ),
                      rightTitles: SideTitles(
                        showTitles: true,
                        textStyle: const TextStyle(color: Colors.white, fontSize: 10),
                        rotateAngle: 90,
                        getTitles: (double value) {
                          if (value == 0) {
                            return '';
                          }
                          return '${value.toInt()}0k';
                        },
                        interval: 5,
                        margin: 8,
                        reservedSize: 0,
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (value) => value % 5 == 0,
                      getDrawingHorizontalLine: (value) {
                        if (value == 0) {
                          return FlLine(color: Color(0xff363753), strokeWidth: 3);
                        }
                        return FlLine(
                          color: Color(0xff2a2747),
                          strokeWidth: 0.8,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            y: 15.1,
                            width: barWidth,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            rodStackItem: const [
                              BarChartRodStackItem(0, 2, Color(0xff2bdb90)),
                              BarChartRodStackItem(2, 5, Color(0xffffdd80)),
                              BarChartRodStackItem(5, 7.5, Color(0xffff4d94)),
                              BarChartRodStackItem(7.5, 15.5, Color(0xff19bfff)),
                            ],
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            y: 14,
                            width: barWidth,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            rodStackItem: const [
                              BarChartRodStackItem(0, 1.8, Color(0xff2bdb90)),
                              BarChartRodStackItem(1.8, 4.5, Color(0xffffdd80)),
                              BarChartRodStackItem(4.5, 7.5, Color(0xffff4d94)),
                              BarChartRodStackItem(7.5, 14, Color(0xff19bfff)),
                            ],
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            y: 13,
                            width: barWidth,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            rodStackItem: const [
                              BarChartRodStackItem(0, 1.5, Color(0xff2bdb90)),
                              BarChartRodStackItem(1.5, 3.5, Color(0xffffdd80)),
                              BarChartRodStackItem(3.5, 7, Color(0xffff4d94)),
                              BarChartRodStackItem(7, 13, Color(0xff19bfff)),
                            ],
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            y: 13.5,
                            width: barWidth,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            rodStackItem: const [
                              BarChartRodStackItem(0, 1.5, Color(0xff2bdb90)),
                              BarChartRodStackItem(1.5, 3, Color(0xffffdd80)),
                              BarChartRodStackItem(3, 7, Color(0xffff4d94)),
                              BarChartRodStackItem(7, 13.5, Color(0xff19bfff)),
                            ],
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            y: 18,
                            width: barWidth,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            rodStackItem: const [
                              BarChartRodStackItem(0, 2, Color(0xff2bdb90)),
                              BarChartRodStackItem(2, 4, Color(0xffffdd80)),
                              BarChartRodStackItem(4, 9, Color(0xffff4d94)),
                              BarChartRodStackItem(9, 18, Color(0xff19bfff)),
                            ],
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(
                            y: 17,
                            width: barWidth,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            rodStackItem: const [
                              BarChartRodStackItem(0, 1.2, Color(0xff2bdb90)),
                              BarChartRodStackItem(1.2, 2.7, Color(0xffffdd80)),
                              BarChartRodStackItem(2.7, 7, Color(0xffff4d94)),
                              BarChartRodStackItem(7, 17, Color(0xff19bfff)),
                            ],
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 6,
                        barRods: [
                          BarChartRodData(
                            y: 16,
                            width: barWidth,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            rodStackItem: const [
                              BarChartRodStackItem(0, 1.2, Color(0xff2bdb90)),
                              BarChartRodStackItem(1.2, 6, Color(0xffffdd80)),
                              BarChartRodStackItem(6, 11, Color(0xffff4d94)),
                              BarChartRodStackItem(11, 17, Color(0xff19bfff)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(),
      ],
    );
  }

  List<Widget> _buildIndicators() {
    List<String> categoryList = [];
    for (Map map in widget.data) {
      map.forEach((key, value) {
        categoryList.add(key);
      });
    }
    categoryList = categoryList.toSet().toList();
    print(categoryList);
    categoryList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    print(categoryList);
    for (Map map in widget.data) {
      var mapList = map.entries.toList();
      return mapList.map((e) {
        int index = mapList.indexOf(e);
        return Indicator(
          color: kCategoryColorList[index],
          text: e.key,
          onTap: () {
            setState(() {
              _touchedIndex.contains(index)
                  ? _touchedIndex.remove(index)
                  : _touchedIndex.add(index);
            });
          },
          isSquare: false,
          isSelectable: true,
          size: _touchedIndex.contains(index) ? 18 : 16,
          textColor: _touchedIndex.contains(index) ? Colors.black : Colors.grey,
        );
      }).toList();
    }
  }
}

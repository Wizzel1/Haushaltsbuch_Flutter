import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';
import 'package:flutter_haushaltsbuch/components/chartIndicator.dart';
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

  List<String> _selectedCategories = [];
  List<String> _categoryList = [];
  double _min = 0;
  double _max = 0;

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
                    maxY: 10,
                    groupsSpace: 12,
                    barTouchData: BarTouchData(
                      enabled: true,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        textStyle: TextStyle(color: Colors.black, fontSize: 12),
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
                        textStyle: TextStyle(color: Colors.black, fontSize: 15),
                        rotateAngle: 0,
                        getTitles: (double value) {
                          if (value == 0) {
                            return '';
                          }
                          return '${value.toInt()}';
                        },
                        interval: 5,
                        margin: 8,
                        reservedSize: 30,
                      ),
                      rightTitles: SideTitles(
                        showTitles: false,
                        textStyle: TextStyle(color: Colors.black, fontSize: 10),
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
                    barGroups: _buildChartGroupData(),
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
    for (Map map in widget.data) {
      map.forEach((key, value) {
        _categoryList.add(key);
      });
    }
    _categoryList = _categoryList.toSet().toList();
    _categoryList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    return _categoryList.map((element) {
      int index = _categoryList.indexOf(element);
      return Indicator(
        color: kCategoryColorList[index],
        text: element,
        onTap: () {
          setState(() {
            _selectedCategories.contains(element)
                ? _selectedCategories.remove(element)
                : _selectedCategories.add(element);
            print(_selectedCategories);
          });
        },
        isSquare: false,
        isSelectable: true,
        size: _selectedCategories.contains(element) ? 18 : 16,
        textColor: _selectedCategories.contains(element) ? Colors.black : Colors.grey,
      );
    }).toList();
  }

  List<BarChartGroupData> _buildChartGroupData() {
    return widget.data.map((e) {
      int index = widget.data.indexOf(e);
      double maxAmount = _getMaxAmount(e);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: maxAmount,
            width: barWidth,
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            rodStackItem: _buildRodStackItems(e, maxAmount),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxAmount(Map categories) {
    double summary = 0;
    categories.forEach((key, value) {
      summary += value;
    });
    return summary / 100;
  }

  List<BarChartRodStackItem> _buildRodStackItems(Map totals, double maxAmount) {
    int indexModifier = 0;

    List<MapEntry> _sortedEntries = totals.entries.toList()
      ..sort((entry1, entry2) {
        return entry1.key.toString().toLowerCase().compareTo(entry2.key.toString().toLowerCase());
      });

    return _sortedEntries.map((entry) {
      int index = _sortedEntries.indexOf(entry);
      List minMaxList = _getChartPieceRanges(index, maxAmount, entry);
      if (entry.key == _categoryList[index]) {
        return BarChartRodStackItem(minMaxList[0], minMaxList[1], kCategoryColorList[index]);
      } else {
        while (entry.key != _categoryList[index + indexModifier]) {
          indexModifier++;
        }
        return BarChartRodStackItem(
            minMaxList[0], minMaxList[1], kCategoryColorList[index + indexModifier]);
      }
    }).toList();
  }

  List<double> _getChartPieceRanges(int index, double maxAmount, MapEntry entry) {
    if (index == 0) {
      _max = entry.value / 100;
      return [0, _max];
    } else {
      _min = _max;
      _max = _min + entry.value / 100;
      return [_min, _max];
    }
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/components/pieChartIndicator.dart';

class StatisticsPieChart extends StatefulWidget {
  StatisticsPieChart({this.data, this.touchedIndex});

  final Map data;
  final int touchedIndex;
  List<Color> colorList = [Color(0xff0293ee), Color(0xfff8b250), Color(0xff845bef)];

  @override
  State<StatefulWidget> createState() => StatisticsPieChartState();
}

class StatisticsPieChartState extends State<StatisticsPieChart> {
  int _touchedIndex;
  double totalAmount;

  @override
  Widget build(BuildContext context) {
    _getTotalAmount();
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildIndicators(),
        ),
        SizedBox(
          height: 18,
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            _touchedIndex = -1;
                          } else {
                            _touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: true,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 80,
                      sections: showingSections()),
                ),
              ),
              Positioned.fill(
                //Text in the middle of the piechart
                child: Align(
                  alignment: Alignment.center,
                  child: Text(_getDisplayText(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 28,
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    var mapList = widget.data.entries.toList();
    return List.generate(mapList.length, (i) {
      final isTouched = i == _touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      double valueAtIndex = mapList[i].value.runtimeType == int
          ? double.parse(mapList[i].value.toString())
          : mapList[i].value;
      return PieChartSectionData(
        color: widget.colorList[i],
        value: valueAtIndex,
        title: _getPercentage(valueAtIndex),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    });
  }

  List<Widget> _buildIndicators() {
    var mapList = widget.data.entries.toList();
    return mapList.map((e) {
      int index = mapList.indexOf(e);
      return Indicator(
        color: widget.colorList[index],
        text: e.key,
        onTap: () {
          setState(() {
            _touchedIndex == index ? _touchedIndex = -1 : _touchedIndex = index;
          });
        },
        isSquare: false,
        isSelectable: false,
        size: _touchedIndex == index ? 18 : 16,
        textColor: _touchedIndex == index ? Colors.black : Colors.grey,
      );
    }).toList();
  }

  _getTotalAmount() {
    totalAmount = 0.0;
    var mapList = widget.data.entries.toList();
    for (var entry in mapList) {
      setState(() {
        totalAmount += entry.value;
      });
    }
  }

  String _getAmountAt(int index) {
    var mapList = widget.data.entries.toList();
    return '${mapList[index].value.toStringAsFixed(2)}€';
  }

  String _getDisplayText() {
    if (_touchedIndex != null && _touchedIndex >= 0) {
      return _getAmountAt(_touchedIndex);
    } else {
      return '${totalAmount.toStringAsFixed(2)}€';
    }
  }

  String _getPercentage(double value) {
    return '${((value / totalAmount) * 100).round()}%';
  }
}

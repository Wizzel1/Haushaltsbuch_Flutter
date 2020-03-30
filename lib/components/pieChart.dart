import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/components/pieChartIndicator.dart';

class StatisticsPieChart extends StatefulWidget {
  StatisticsPieChart({this.data});

  final Map data;
  List<Color> colorList = [Color(0xff0293ee), Color(0xfff8b250), Color(0xff845bef)];

  @override
  State<StatefulWidget> createState() => StatisticsPieChartState();
}

class StatisticsPieChartState extends State<StatisticsPieChart> {
  int touchedIndex;
  int totalAmount;

  @override
  Widget build(BuildContext context) {
    _getTotalAmount();
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildIndicators(widget.data),
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
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
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
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: widget.colorList[i],
        value: double.parse(mapList[i].value.toString()),
        title: _getPercentage(double.parse(mapList[i].value.toString())),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    });
  }

  List<Widget> _buildIndicators(Map data) {
    var mapList = data.entries.toList();
    return mapList.map((e) {
      int index = mapList.indexOf(e);
      return Indicator(
        color: widget.colorList[index],
        text: e.key,
        isSquare: false,
        size: touchedIndex == index ? 18 : 16,
        textColor: touchedIndex == index ? Colors.black : Colors.grey,
      );
    }).toList();
  }

  _getTotalAmount() {
    totalAmount = 0;
    var mapList = widget.data.entries.toList();
    for (var entry in mapList) {
      setState(() {
        totalAmount += entry.value;
      });
    }
  }

  String _getAmountAt(int index) {
    var mapList = widget.data.entries.toList();
    return '${mapList[index].value}€';
  }

  String _getDisplayText() {
    if (touchedIndex != null && touchedIndex >= 0) {
      return _getAmountAt(touchedIndex);
    } else {
      return '$totalAmount€';
    }
  }

  String _getPercentage(double value) {
    return '${((value / totalAmount) * 100).round()}%';
  }
}

//import 'package:fl_chart/fl_chart.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_haushaltsbuch/models/transfer.dart';
//import 'package:flutter_haushaltsbuch/utility/constants.dart';
//
//class StatisticBarChart extends StatefulWidget {
//  StatisticBarChart({this.data, this.dateRange});
//
//  ///List of transfers from provider, sorted by date
//  final List<Map> data;
//  final List<DateTime> dateRange;
//  @override
//  State<StatefulWidget> createState() => StatisticBarChartState();
//}
//
//class StatisticBarChartState extends State<StatisticBarChart> {
//  double _barWidth = 15;
//  double _radius = 5;
//  double _maxAmount = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    _getMaxAmount(widget.data);
//    return BarChart(
//      BarChartData(
//          alignment: BarChartAlignment.spaceAround,
//          maxY: _maxAmount,
//          barTouchData: BarTouchData(
//            enabled: false,
//            touchTooltipData: BarTouchTooltipData(
//              tooltipBgColor: Colors.transparent,
//              tooltipPadding: const EdgeInsets.all(0),
//              tooltipBottomMargin: 8,
//              getTooltipItem: (
//                BarChartGroupData group,
//                int groupIndex,
//                BarChartRodData rod,
//                int rodIndex,
//              ) {
//                return BarTooltipItem(
//                  rod.y.round().toString(),
//                  TextStyle(
//                    color: Color(0xff7589a2),
//                    fontWeight: FontWeight.bold,
//                  ),
//                );
//              },
//            ),
//          ),
//          titlesData: FlTitlesData(
//            show: true,
//            bottomTitles: SideTitles(
//              showTitles: true,
//              textStyle: TextStyle(
//                  color: const Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
//              margin: 20,
//              getTitles: (double value) {
//                switch (value.toInt()) {
//                  case 0:
//                    return 'Mn';
//                  case 1:
//                    return 'Te';
//                  case 2:
//                    return 'Wd';
//                  case 3:
//                    return 'Tu';
//                  case 4:
//                    return 'Fr';
//                  case 5:
//                    return 'St';
//                  case 6:
//                    return 'Sn';
//                  case 7:
//                    return 'Sn';
//                  case 8:
//                    return 'Sn';
//                  case 9:
//                    return 'Sn';
//                  case 10:
//                    return 'Sn';
//                  default:
//                    return '';
//                }
//              },
//            ),
//            leftTitles: SideTitles(
//              showTitles: true,
//              margin: 10,
//              textStyle: TextStyle(
//                  color: const Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
//              interval: _getInterval(widget.data),
//            ),
//          ),
//          borderData: FlBorderData(
//            show: false,
//          ),
//          barGroups: []
////        _createBarGroupData(widget.providerData),
//          ),
//    );
//  }
//
//  double _getInterval(List dataList) {
//    if (dataList.isEmpty) {
//      return 5;
//    } else {
//      double amount = dataList[0].amount;
//      if (amount > 20 && amount < 100) {
//        return 10;
//      } else if (amount > 100 && amount < 500) {
//        return 50;
//      } else if (amount > 500 && amount < 2500) {
//        return 250;
//      }
//    }
//  }
//
//  ///Gets the maximum Value based on the given [dataSet].
//  void _getMaxAmount(List<Transfer> dataSet) {
//    _maxAmount = 0;
//    if (widget.data.isEmpty) {
//      return;
//    }
//    for (var entry in dataSet) {
//      if (entry.amount > _maxAmount) {
//        _maxAmount = entry.amount;
//      }
//    }
//    _addToMaxAmount();
//  }
//
//  ///Adds a buffer to maxAmount to make sure the bars never reach the top.
//  void _addToMaxAmount() {
//    if (_maxAmount > 100 && _maxAmount <= 500) {
//      _maxAmount += 50;
//    } else if (_maxAmount > 500 && _maxAmount < 1000) {
//      _maxAmount += 100;
//    } else if (_maxAmount > 100 && _maxAmount < 500) {
//      _maxAmount += 50;
//    }
//  }
//
//  List<BarChartGroupData> _createBarGroupData(List<Map> dataSet) {
//    List<BarChartGroupData> chartGroupData = [];
//
//    dataSet.forEach((element) {
//      return BarChartGroupData(x: 0, barRods: [
//        BarChartRodData(
//            y: widget.data.isEmpty ? 0 : widget.data[0].amount,
//            width: _barWidth,
//            borderRadius: BorderRadius.circular(_radius),
//            color: kTextColorHeading)
//      ], showingTooltipIndicators: [
//        0
//      ]);
//    });
//  }
//}

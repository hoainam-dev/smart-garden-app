import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../models/DataPoint.dart';
// Các điểm dữ liệu mẫu
List<DataPoint> humidityData = [
  // Khởi tạo ban đầu 10 điểm dữ liệu
  DataPoint(x: DateTime(2023, 2, 1), y: 70),
  DataPoint(x: DateTime(2023, 2, 2), y: 76),
  DataPoint(x: DateTime(2023, 2, 3), y: 100),
  DataPoint(x: DateTime(2023, 2, 4), y: 82),
  DataPoint(x: DateTime(2023, 2, 5), y: 66),
  DataPoint(x: DateTime(2023, 2, 6), y: 50),
  DataPoint(x: DateTime(2023, 2, 7), y: 60),
  DataPoint(x: DateTime(2023, 2, 8), y: 54),
  DataPoint(x: DateTime(2023, 2, 9), y: 60),
  DataPoint(x: DateTime(2023, 2, 10), y: 48),
];

List<DataPoint> temperatureData = [
  DataPoint(x: DateTime(2023, 2, 1), y: 22),
  DataPoint(x: DateTime(2023, 2, 2), y: 21),
  DataPoint(x: DateTime(2023, 2, 3), y: 20),
  DataPoint(x: DateTime(2023, 2, 4), y: 22),
  DataPoint(x: DateTime(2023, 2, 5), y: 23),
  DataPoint(x: DateTime(2023, 2, 6), y: 25),
  DataPoint(x: DateTime(2023, 2, 7), y: 24),
  DataPoint(x: DateTime(2023, 2, 8), y: 26),
  DataPoint(x: DateTime(2023, 2, 9), y: 27),
  DataPoint(x: DateTime(2023, 2, 10), y: 26),
];

Widget Humi (DataPoint humidata) {
  // Thêm 10 điểm dữ liệu mới
   humidityData.add(humidata);
  // Lấy 10 điểm gần nhất
   // Lấy 10 điểm gần nhất
   final recentData = humidityData.sublist(max(0, humidityData.length - 10));
   return SfCartesianChart(
     tooltipBehavior: TooltipBehavior(enable: true),
     primaryXAxis: DateTimeCategoryAxis(
       intervalType: DateTimeIntervalType.months,
         dateFormat: DateFormat.Hm()
     ), // Assuming your X-axis is of type DateTime
     series: <ChartSeries>[
       ColumnSeries<DataPoint, DateTime>(
         dataSource: recentData,
         xValueMapper: (data, _) => data.x,
         yValueMapper: (data, _) => data.y,
         borderRadius: BorderRadius.all(Radius.circular(15)),

         pointColorMapper: (data, _) {
           if (data.y < 50) {
             return Colors.red;
           }
           return Colors.blue;
         },
         enableTooltip: true,
       )

     ],


   );
}// Biểu đồ độ ẩm

Widget Temp (DataPoint tempData) {
  tempData != null ? temperatureData.add(tempData) : temperatureData = temperatureData;

  // Lấy giá trị gần nhất nếu vượt ngưỡng
  final latestData = humidityData.sublist(max(0, humidityData.length - 10));
  return // Biểu đồ nhiệt độ
    SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeCategoryAxis(
          intervalType: DateTimeIntervalType.months,
          dateFormat: DateFormat.Hm()
      ),
    series: <ChartSeries>[
      LineSeries<DataPoint, DateTime>(
          dataSource: temperatureData,
          xValueMapper: (data, _) => data.x,
          yValueMapper: (data, _) => data.y,
          color: Colors.blue,
        width: 5,
        enableTooltip: true
      )
    ],

    // Hiển thị giá trị và thời gian gần nhất
    // annotations: [
    //   CartesianChartAnnotation(
    //     widget: Text('${latestData.y}\n${DateFormat('HH:mm').format(latestData.x)}'),
    //     coordinateUnit: CoordinateUnit.point,
    //     x: latestData.x,
    //     y: latestData.y,
    //   )
    // ],
  );
}

Widget  Soil (double Smoisture) {
  Smoisture == null ? Smoisture = 60 : Smoisture = Smoisture ;
  return // Biểu đồ độ ẩm đất
    SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 35, color: Colors.red),
            GaugeRange(startValue: 35, endValue: 60, color: Colors.orange),
            GaugeRange(startValue: 60, endValue: 100, color: Colors.green),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(value: Smoisture),
          ],
        )
      ],
    );
}

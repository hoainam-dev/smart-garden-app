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


// Giá trị độ ẩm đất
double soilMoisture = 60;


Widget Humi () {
  // Thêm 10 điểm dữ liệu mới
  for (int i = 0; i < 10; i++) {
    humidityData.add(
        DataPoint(x: DateTime.now().add(Duration(hours: i)), y: Random().nextInt(100))
    );
  }
  // Lấy 10 điểm gần nhất
  final recentData = humidityData.sublist(humidityData.length - 10);
  return SfCartesianChart(
    tooltipBehavior: TooltipBehavior(enable: true),
    primaryXAxis: CategoryAxis(),
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
          enableTooltip: true
      )

    ],
  );
}// Biểu đồ độ ẩm

Widget Temp () {
  // Giá trị ngưỡng
  final threshold = 10;
  // Lấy giá trị gần nhất nếu vượt ngưỡng
  final latestData = temperatureData.lastWhere((d) => d.y >= threshold);
  return // Biểu đồ nhiệt độ
    SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeAxis(),
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
    annotations: [
      CartesianChartAnnotation(
        widget: Text('${latestData.y}\n${DateFormat('HH:mm').format(latestData.x)}'),
        coordinateUnit: CoordinateUnit.point,
        x: latestData.x,
        y: latestData.y,
      )
    ],
  );
}

Widget  Soil () {
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
            NeedlePointer(value: soilMoisture),
          ],
        )
      ],
    );
}

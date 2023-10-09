// import 'dart:html';
//
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
//
// class SensorChart extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       LineChartData(
//         gridData: FlGridData(show: false),
//         titlesData: FlTitlesData(show: false),
//         borderData: FlBorderData(
//           show: true,
//           border: Border.all(
//             color: const Color(0xff37434d),
//             width: 1,
//           ),
//         ),
//         minX: 0,
//         maxX: temperatureSensors.length.toDouble() - 1,
//         minY: 0,
//         maxY: 100, // Điều chỉnh giới hạn trục y tùy theo dữ liệu của bạn
//         lineBarsData: [
//           LineChartBarData(
//             spots: temperatureSensors.map((sensor) {
//               return FlSpot(sensor.time.millisecondsSinceEpoch.toDouble(), double.parse(sensor.value));
//             }).toList(),
//             isCurved: true,
//             color:  Color(0xff4af699),
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: false),
//           ),
//           LineChartBarData(
//             spots: humiditySensors.map((sensor) {
//               return FlSpot(sensor.time.millisecondsSinceEpoch.toDouble(), double.parse(sensor.value));
//             }).toList(),
//             isCurved: false,
//             color: Color(0xffaa4cfc),
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: false),
//           ),
//           LineChartBarData(
//             spots: soilMoistureSensors.map((sensor) {
//               return FlSpot(sensor.time.millisecondsSinceEpoch.toDouble(), double.parse(sensor.value));
//             }).toList(),
//             isCurved: false,
//             color:  Color(0xff27b6fc),
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: false),
//           ),
//         ],
//         lineBarsData: [
//           LineChartBarData(
//             spots: [],
//             isCurved: false,
//             color: Color(0xff27b6fc),
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: false),
//           ),
//         ],
//       ),
//     );
//   }
// }

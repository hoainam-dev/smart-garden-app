// crop_calendar_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/screens/admin/CropDetailScreen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smart_garden_app/models/Crop.dart';
import 'package:smart_garden_app/models/CropActivity.dart';


class CropCalendarScreen extends StatefulWidget {
  final Crop crop;
  final List<CropActivity> activities;

  CropCalendarScreen({required this.crop, required this.activities});

  @override
  _CropCalendarScreenState createState() => _CropCalendarScreenState();
}

class _CropCalendarScreenState extends State<CropCalendarScreen> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  List<CropActivity> activities = [];
  Map<DateTime, List<CropActivity>> events = {};
  List<CropActivity>? newActivities;
  DateTime? selectedDay;
  @override
  void initState() {
    super.initState();
    // Lấy danh sách hoạt động của cây trồng
    activities = widget.activities;
    // Tạo bản đồ các hoạt động theo ngày
    events = groupActivitiesByDate(activities);
  }

  // Hàm tạo bản đồ các hoạt động theo ngày
  Map<DateTime, List<CropActivity>> groupActivitiesByDate(
      List<CropActivity> activities) {
    Map<DateTime, List<CropActivity>> events = {};
    for (var activity in activities) {
      final date = DateTime(activity.dueDate.year, activity.dueDate.month,
          activity.dueDate.day);
      if (events[date] == null) {
        events[date] = [];
      }
      events[date]!.add(activity);
    }
    return events;
  }

  // void addActivities(List<CropActivity> newActivities) {
  //   for (var activity in newActivities) {
  //     final date = DateTime(activity.dueDate.year, activity.dueDate.month, activity.dueDate.day);
  //     if (events[date] == null) {
  //       events[date] = [];
  //     }
  //     events[date]!.add(activity);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.crop.name} Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: calendarFormat,
            firstDay: DateTime(2000),
            focusedDay: focusedDay,
            lastDay: DateTime(2050),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              this.focusedDay = focusedDay;
            },
            // Thêm các hoạt động vào lịch
            eventLoader: (day) {
              final eventsOnDay = events[day];
              print(eventsOnDay);
              return eventsOnDay ?? [];

            },
          ),
          if (focusedDay != null)
            Expanded(
              child: events[focusedDay] != null
                  ? ListView.builder(
                itemCount: events[focusedDay]!.length,
                itemBuilder: (context, index) {
                  final activity = events[focusedDay]![index];
                  return ListTile(
                    title: Text(activity.title),
                    subtitle: Text(activity.dueDate.toString()),
                  );
                },
              )
                  : Container(
                child: Text('No Activity'),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          newActivities = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CropDetailScreen(crop: widget.crop,)),
          );
          if (newActivities != null) {
            groupActivitiesByDate(newActivities!);
            newActivities = null;
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

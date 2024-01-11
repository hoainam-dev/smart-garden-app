import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smart_garden_app/util/Calendar.dart';

import '../../models/CropActivity.dart';

class ActivityCalendar extends StatefulWidget {
  const ActivityCalendar({Key? key, required this.idPlant}) : super(key: key);
  final String idPlant;

  @override
  State<ActivityCalendar> createState() => _ActivityCalendarState();
}

class _ActivityCalendarState extends State<ActivityCalendar> {
  // Khai báo form key để validate form
  final _formKey = GlobalKey<FormState>();
// Controller cho các trường trong form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  List<CropActivity> activityDates = [];
  late CollectionReference _eventsRef;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _selectedDate = DateTime.now();
  var _selectedDateStr;

  @override
  void initState() {
    _selectedDateStr = _formatDate(_selectedDate);
    _selectedDay = _focusedDay;
    _eventsRef = FirebaseFirestore.instance
        .collection('plants')
        .doc(widget.idPlant)
        .collection('cropActivity');
    super.initState();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  List<CropActivity> _getActivityList(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((doc) => CropActivity(
      id: doc.id,
      status: doc['status'],
      nameActivity: doc['nameActivity'],
      dateTime: doc['dateTime'].toDate(),
    ))
        .toList();
  }
// Hàm mở form modal bottom sheet
  void _openEntryForm(){
    // Hiển thị modal bottom sheet
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Thêm hoạt động mới"),
            content: Card(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: "Tên hoạt động"),
                      // validator: (value) {
                      //   if(value!.isEmpty) {
                      //     return "Vui lòng nhập tên hoạt động";
                      //   }
                      //   return null;
                      // },
                    ),
                    TextFormField(
                      controller: _descriptionController ,
                      decoration: InputDecoration(hintText: "Mô tả"),
                    ),
                    TextFormField(
                      controller: _statusController ,
                      decoration: InputDecoration(hintText: "Trạng thái"),
                    ),
                    ElevatedButton(
                        child: Text("Lưu"),
                        onPressed: _submit
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
  void _addEvent(String name, String description, String isDone) async {
    // Tạo document mới chứa dữ liệu sự kiện
    Map<String, dynamic> event = {
      'nameActivity': name,
      'description': description,
      'status': isDone,
      'dateTime': DateTime.now(),
    };

    // Thêm document vào collection events
    await _eventsRef.add(event);

  }
// Hàm xử lý khi nhấn Lưu
  void _submit() {
    // Validate form

      // Lấy dữ liệu
      String name = _nameController.text;
      String description = _descriptionController.text;
      String status = _statusController.text;
      // Thêm sự kiện vào danh sách
      _addEvent(name, description, status);
      // Đóng modal bottom sheet
      Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Calendar
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (activityDates.any((element) => element.dateTime.day == day.day &&
                    element.dateTime.month == day.month &&
                    element.dateTime.year == day.year)) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.red, // You can change the marker color
                      shape: BoxShape.circle,
                    ),
                  );
                } else  {
                  return Container();
                }
              },
            ),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedDateStr = _formatDate(_selectedDay!);
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _rangeStart = start;
                _rangeEnd = end;
                _focusedDay = focusedDay;
              });
            },
          ),

          // To do list
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('plants')
                  .doc(widget.idPlant)
                  .collection('cropActivity')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return const Center(child: Text('No data available.'));
                }

                activityDates = _getActivityList(snapshot.data as QuerySnapshot);

                List<CropActivity> activitiesOnSelectedDate = activityDates
                    .where((activity) => _formatDate(activity.dateTime) == _selectedDateStr)
                    .toList();

                return activitiesOnSelectedDate.isNotEmpty
                    ? ListView.builder(
                  itemCount: activitiesOnSelectedDate.length,
                  itemBuilder: (BuildContext context, int index) {
                    var activity = activitiesOnSelectedDate[index];
                    return Container(
                        margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                    ),
                     child: CheckboxListTile(
                      title: Text(
                        '${activity.nameActivity} - ${_formatDate(activity.dateTime)}',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: true,
                      onChanged: (newValue) {
                        // Update the state or perform any action on checkbox change
                        // For example, you can update the 'status' in Firestore here
                        // based on newValue.
                      },
                     )
                    );

                  },
                )
                    : Column(
                  children: [
                      Center(
                      child: Text('No activity on selected date.'),
                      ),
                    ElevatedButton(onPressed: _openEntryForm, child: Text("Add Activity"))
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

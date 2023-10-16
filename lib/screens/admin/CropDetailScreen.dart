import 'package:flutter/material.dart';
import 'package:smart_garden_app/models/Crop.dart';
import 'package:smart_garden_app/models/CropActivity.dart';
import 'package:smart_garden_app/screens/admin/CropCalendarScreen.dart';

class CropDetailScreen extends StatefulWidget {
  final Crop crop;

  CropDetailScreen({required this.crop});

  @override
  _CropDetailScreenState createState() => _CropDetailScreenState();
}

class _CropDetailScreenState extends State<CropDetailScreen> {
  final _activities = <CropActivity>[]; // danh sách activities

  // Thêm activity
  void _addActivity() async {
    // Khai báo biến newActivity
    CropActivity newActivity = CropActivity(
      id: '1',
      cropId: '1',
      title: '',
      dueDate: DateTime.now(),
    );

    // Mở dialog để nhập thông tin activity mới
    final result = await showDialog<CropActivity>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  newActivity.title = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(newActivity);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );

    // Thêm đối tượng mới vào mảng activities
    if (result != null) {
      setState(() {
        _activities.add(result);
      });
    }
  }


  // Xóa activity
  void _deleteActivity(CropActivity activity) {
    setState(() {
      _activities.remove(activity);
    });
  }

  // Chuyển sang màn hình lịch
  void _goToCalendar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CropCalendarScreen(
          crop: widget.crop,
          activities: _activities,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crop.name),
      ),
      body: ListView(
        children: [
          // Hiển thị thông tin cây trồng
          Text('Planted: ${widget.crop.plantedDate}'),
          Text('Harvest in: ${widget.crop.harvestDays} days'),

          // Danh sách activities
          ListView.builder(
            shrinkWrap: true,
            itemCount: _activities.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(_activities[index].id),
                onDismissed: (direction) {
                  _deleteActivity(_activities[index]);
                },
                child: Card(
                  child: ListTile(
                    title: Text(_activities[index].title),
                    subtitle: Text(_activities[index].dueDate.toString()),
                  ),
                ),
              );
            },
          ),

          // Nút thêm activity
          ElevatedButton(
            onPressed: _addActivity,
            child: Text('Add Activity'),
          ),

          // Nút xem lịch
          ElevatedButton(
            onPressed: _goToCalendar,
            child: Text('Calendar'),
          ),
        ],
      ),
    );
  }
}

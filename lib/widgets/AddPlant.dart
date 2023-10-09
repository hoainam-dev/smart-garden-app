import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class AddPlantScreen extends StatefulWidget {
  @override
  _AddPlantScreenState createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _plantingDate = DateTime.now();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _plantingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate != null && pickedDate != _plantingDate) {
        setState(() {
          _plantingDate = pickedDate;
        });
      }
    });
  }

  void _savePlantData() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final location = _locationController.text;
    final status = _statusController.text;

    // Kết nối với Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Thêm dữ liệu vào Firestore
      await firestore.collection('plants').add({
        'name': name,
        'description': description,
        'plantingDate': _plantingDate,
        'location': location,
        'status': status,
      });

      // Đóng màn hình và quay lại màn hình trước đó (hoặc thực hiện hành động tương ứng)
      Navigator.of(context).pop();
    } catch (error) {
      print('Lỗi khi lưu dữ liệu vào Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Cây Cối'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Tên cây'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Mô tả'),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Ngày Trồng'),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(_plantingDate)),
                  onTap: () => _showDatePicker(context),
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Vị trí'),
                ),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: 'Trạng thái'),
                ),
                ElevatedButton(
                  onPressed: _savePlantData,
                  child: Text('Thêm cây'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

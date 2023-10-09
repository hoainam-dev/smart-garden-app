// add_crop_screen.dart
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../models/Crop.dart';
import 'CropDetailScreen.dart';

class AddCropScreen extends StatefulWidget {
  @override
  _AddCropScreenState createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  var random = Random();
  // các controller và biến
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final plantedDateController = TextEditingController();
  final harvestDaysController = TextEditingController();
  DateTime? selectedDate ;
  @override
  void initState() {
    selectedDate = null; // gán giá trị ban đầu
    super.initState();
  }
  _submit() {
    if (formKey.currentState!.validate()) {
      // Tạo đối tượng Crop
      Crop crop = Crop(
        id: random.nextInt(10),
          name: nameController.text,
          plantedDate: selectedDate!,
          harvestDays: int.parse(harvestDaysController.text)
      );
      // Lưu vào database
      // ...

      // Chuyển sang màn hình chi tiết cây trồng
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CropDetailScreen(crop: crop ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Add Crop"),),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Crop name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter crop name';
                    }
                    return null;
                  }
              ),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null ? 'Chọn ngày trồng' : DateFormat('dd/MM/yyyy').format(selectedDate!),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        DatePicker.showDatePicker(
                            context,
                            onConfirm: (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                        );
                      },
                      child: Text('Chọn ngày')
                  )
                ],
              ),
              TextFormField(
                  controller: plantedDateController,
                  decoration: InputDecoration(labelText: "Planted date"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter planted date';
                    }
                    return null;
                  }
              ),

              TextFormField(
                  controller: harvestDaysController,
                  decoration: InputDecoration(labelText: "Days until harvest"),
                  validator: (value) {
                    int? days = int.tryParse(value ?? '');
                    if (days == null || days <= 0) {
                      return 'Please enter valid days';
                    }
                    return null;
                  }
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }

}
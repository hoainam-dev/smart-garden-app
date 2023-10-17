// plant_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/models/Plant.dart';
import 'package:smart_garden_app/widgets/AddPlant.dart';
import 'package:smart_garden_app/screens/admin/Model.dart';

class PlantScreen extends StatefulWidget {
  @override
  _PlantScreenState createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  List<Plant> plants = [];
  @override
  void initState() {
    super.initState();
    fetchPlantsFromFirebase().then((plantList) {
      setState(() {
        print(plants.length);
        plants = plantList;
      });
    });
  }

  Future<List<Plant>> fetchPlantsFromFirebase() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('plants').get();
    List<Plant> plantList = [];
    querySnapshot.docs.forEach((doc) {
      String id = doc.id;
      // Đọc dữ liệu từ Firebase và tạo đối tượng cây cảnh
      Plant plant = Plant(
        id: id,
        name: doc['name'],
        description: doc['description'],
        plantingDate: doc['plantingDate'].toDate(),
        location: doc['location'],
        status: doc['status'],
      );
      plantList.add(plant);
    });
    return plantList;
  }
  Future<void> deletePlant(String plantId) async {
    try {
      await FirebaseFirestore.instance.collection('plants')
          .doc(plantId)
          .delete();
      setState(() {
        plants.removeWhere((plant) => plant.id == plantId);
      });
    } catch (e) {
      print('Lỗi khi xóa cây: $e');
      // Xử lý lỗi nếu cần
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plants'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => Model(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (BuildContext context, int index) {
          final plant = plants[index];
          return Card(
            child: ListTile(
              title: Text(plant.name),
              subtitle: Text(plant.description),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Hiển thị hộp thoại xác nhận xóa
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Xác nhận xóa cây'),
                        content: Text('Bạn có chắc chắn muốn xóa cây ${plant.name}?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Đóng hộp thoại xác nhận
                              Navigator.of(context).pop();
                            },
                            child: Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Xóa cây và đóng hộp thoại xác nhận
                              deletePlant(plant.id);
                              Navigator.of(context).pop();
                            },
                            child: Text('Xóa'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddPlantScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

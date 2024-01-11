// plant_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_garden_app/models/Plant.dart';
import 'package:smart_garden_app/screens/admin/ActivityCalendar.dart';
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
    fetchPlantsFromFirebase();
  }

  Stream<List<Plant>> fetchPlantsFromFirebase() {
    return FirebaseFirestore.instance.collection('plants').snapshots().map((querySnapshot) {
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
    });
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
      body: StreamBuilder<List<Plant>> (
        stream: fetchPlantsFromFirebase(),
        builder: (BuildContext context , AsyncSnapshot<List<Plant>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
            // tai du lieu
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            // Hiển thị dữ liệu từ Firebase khi có sẵn
            List<Plant> plants = snapshot.data!;
            return ListView.builder(
              itemCount: plants.length,
              itemBuilder: (BuildContext context, int index) {
                final plant = plants[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 4, // Độ nổi của card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bo tròn góc của card
                      side: BorderSide(color: Colors.grey, width: 0.5), // Viền của card
                    ),
                    color: Colors.white, // Màu nền của card
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0 , bottom: 10),
                      child: ListTile(
                        onTap: () {
                          showModalBottomSheet<void> (
                            context: context,
                            builder: (BuildContext context) {
                              return modelBottom(plant);
                            },
                          );
                        },
                        leading: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // Độ dịch chuyển của bóng
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'https://vcdn-suckhoe.vnecdn.net/2020/01/25/1200px-lettuce-4988502260-1579-6162-4956-1579967909.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(plant.name),
                        subtitle: Text(plant.location),
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
                    ),
                  ),
                );
              },
            );
          }
        }
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
  Widget modelBottom (Plant plant) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(plant.plantingDate);
    int daysDifference = difference.inDays;
    print(daysDifference);
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width:MediaQuery.of(context).size.width ,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 200,
            offset: Offset(1,3),
          ),
        ],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30) , topRight: Radius.circular(30) ,),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              height: 200,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage('https://vcdn-suckhoe.vnecdn.net/2020/01/25/1200px-lettuce-4988502260-1579-6162-4956-1579967909.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              plant.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    plant.description,
                    maxLines: 5,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]
                      ),
                      child: Text(plant.location),
                    )
                ),
                SizedBox(width: 10,),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]
                      ),
                      child: Text(DateFormat('dd/MM/yyyy').format(plant.plantingDate)),
                    )
                ),
                SizedBox(width: 10,),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]
                      ),
                      child: Text(plant.status +": " + daysDifference.toString() + " ngày"),
                    )
                ),
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Màu nền
                onPrimary: Colors.white, // Màu chữ
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Khoảng cách bên trong nút
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ActivityCalendar(idPlant: plant.id, ),
                  ),
                );
              },
              child: Text("Xem lịch canh tác"),
            ),
          ],
        ),
      ),
    );
  }
}

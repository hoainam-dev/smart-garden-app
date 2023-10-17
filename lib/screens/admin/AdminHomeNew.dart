import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/HomeWidget.dart';
import '../auth/LoginOrRegisterPage.dart';
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginOrRegisterPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              signUserOut();
            },
          )
        ],
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          StaggeredGrid.count(
            crossAxisCount: 6,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            axisDirection: AxisDirection.down,
            children:   const [
              StaggeredGridTile.count(
                crossAxisCellCount: 6,
                mainAxisCellCount: 3.7,
                child: Tile(index: 0),
              ),
            ],
          ),
          SizedBox(height: 35,),
          StaggeredGrid.count(
              crossAxisCount: 6,
            mainAxisSpacing: 6 ,
              crossAxisSpacing: 6,
            children: const [
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: Tile(index: 1),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: Tile(index: 2),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: Tile(index: 3),
              ),
            ],
          ),
          StaggeredGrid.count(
            crossAxisCount: 6,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            axisDirection: AxisDirection.down,
            children: const [
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: Tile(index: 4),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 2,
                child: Tile(index: 5),
              ),
            ],
          ),
          StaggeredGrid.count(
            crossAxisCount: 6,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            axisDirection: AxisDirection.down,
            children: const [
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 2,
                child: Tile(index: 6),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: Tile(index: 7),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final int index;

  const Tile({required this.index});

  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return Carouse();
      case 1:
        return SensorInfoCard(
          icon: SvgPicture.asset("assets/svg/Frame.svg"),
          title: "Humidity",
          value: "30%",
        );
      case 2:
        return SensorInfoCard(
          icon: SvgPicture.asset("assets/svg/Temp.svg"),
          title: "Temperature",
          value: "30℃",
        );
      case 3:
        return SensorInfoCard(
          icon: SvgPicture.asset("assets/svg/water.svg"),
          title: "Water Level",
          value: "85%",
        );
      case 4 :
        return SensorInfoCard(
          icon: SvgPicture.asset("assets/svg/wifi.svg"),
          title: "Connectivity",
          value: "Online",
        );
      case 5:
        return Nutirient(name:"Nutrient Level",icon: "assets/svg/clock.svg", icon2: "assets/svg/tree.svg", title: "5 Grams Left" , title2: "Refill in 2 days");
      case 6 :
        return Nutirient(name:"Status",icon: "assets/svg/tree1.svg", icon2: "assets/svg/clock1.svg", title: "6 plants rowing" , title2: "Next harvest in 3 days");
      case 7 :
        return SensorInfoCard(
          icon: SvgPicture.asset("assets/svg/light.svg"),
          title: "Light Status",
          value: "On",
        );
      default:
        return Container(
          color: Colors.green,
          // Your tile design implementation here
        );
    }
  }
}

class SensorInfoCard extends StatelessWidget {
  final SvgPicture icon;
  final String title;
  final String value;

  SensorInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 114,
        width: 114,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x1F0C9359),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.only(left: 16, top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/screens/auth/LoginOrRegisterPage.dart';
import 'package:smart_garden_app/screens/auth/auth_page.dart';
import 'package:smart_garden_app/util/authentication.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Chào mừng bạn đến với trang Home Page!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20), // Khoảng cách giữa dòng văn bản và nút
            ElevatedButton(
              onPressed: () {
                // Xử lý sự kiện khi nút được nhấn
              },
              child: Text('Nhấn vào đây'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              accountName: Text('John Doe'),
              accountEmail: Text('john.doe@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/3467446.jpg'),
              ),
            ),
            ListTile(
              title: Text('Trang chủ'),
              leading: Icon(Icons.home),
              onTap: () {
                // Xử lý sự kiện khi mục 1 được chọn
              },
            ),
            ListTile(
              title: Text('Thông tin cá nhân'),
              leading: Icon(Icons.account_circle),
              onTap: () {
                // Xử lý sự kiện khi mục 1 được chọn
              },
            ),
            ListTile(
              title: Text('Đăng xuất'),
              leading: Icon(Icons.output),
              onTap: () async {
                await Authentication.signOut(context: context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
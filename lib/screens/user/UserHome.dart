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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginOrRegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("This is home page"),
          //logout
          Positioned(
            right: 16,
            top: 16,
            child: IconButton(
              onPressed: () async{
                await Authentication.signOut(context: context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      )
    );
  }
}
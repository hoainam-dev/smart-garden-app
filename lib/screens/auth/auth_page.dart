import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/main.dart';
import 'package:smart_garden_app/screens/admin/AdminRoot.dart';
import 'package:smart_garden_app/screens/auth/LoginOrRegisterPage.dart';
import 'package:smart_garden_app/screens/user/UserRoot.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            if(user.email!.contains("admin")){
              return const AdminRoot();
            }else{
              return const UserRoot();
            }

          }
          // user is NOT logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}

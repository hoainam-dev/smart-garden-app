import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/screens/admin/AdminRoot.dart';
import 'package:smart_garden_app/screens/auth/LoginOrRegisterPage.dart';
import 'package:smart_garden_app/screens/user/UserRoot.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // user is logged in
        if (snapshot.hasData) {
          if (snapshot.data!.email=="admin@gmail.com") {
            return AdminRoot();
          } else {
            return UserRoot();
          }
        }
        // user is NOT logged in
        else {
          return LoginOrRegisterPage();
        }
      },
    );
  }
}

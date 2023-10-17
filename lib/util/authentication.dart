import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_garden_app/screens/admin/AdminRoot.dart';
import 'package:smart_garden_app/screens/user/UserRoot.dart';
import 'package:smart_garden_app/service/userService.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SignIn
  Future<User?> signIn(String email, String password) async{
    var user =  await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  //SignOut
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  //Register
  Future<User?> createUser(String name, String email, String password) async {
    final UserService _userService = UserService();
    await _userService.getAllUsers();
    String faceId = _userService.users.length.toString();
    print(faceId);
    var user = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    await _firestore
        .collection("users")
        .doc(user.user!.uid)
        .set({'name': name, 'faceId': faceId, 'email': email});

    return user.user;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final UserService _userService = UserService();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
        //create user in firestore
        await _userService.getUserByEmail(user!.email.toString());
        if(_userService.user==null){
          await _firestore
              .collection("users")
              .doc(user.uid)
              .set({'name': user.displayName, 'email': user.email});
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
              'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
              'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }

    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if(user.email=="admin@gmail.com"){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AdminRoot(),
          ),
        );
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UserRoot(),
          ),
        );
      }
    }

    return firebaseApp;
  }

}
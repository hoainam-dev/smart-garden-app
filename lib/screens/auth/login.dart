import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/components/my_button.dart';
import 'package:smart_garden_app/components/my_textfield.dart';
import 'package:smart_garden_app/components/square_tile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_garden_app/screens/admin/AdminRoot.dart';
import 'package:smart_garden_app/screens/auth/auth_page.dart';
import 'package:smart_garden_app/screens/user/UserRoot.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Initialize Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if(emailController.text.contains('admin@gmail.com')){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminRoot()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserRoot()));
      }
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to the user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to the user
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // sign in with Google method
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        return; // User canceled Google sign-in
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      // You can do something with the user object (e.g., navigate to a new page)
      Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthPage()));
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.zero, // Đặt Padding thành EdgeInsets.zero
              margin: EdgeInsets.zero, // Đặt Margin thành EdgeInsets.zero
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/plants.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Giúp mở rộng Column để lấp đầy màn hình
                children: [
                  const SizedBox(height: 50),

                  // logo
                  Container(
                    width: 100, // Đặt kích thước của hình tròn tại đây
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape
                          .circle, // Đặt hình dạng của container thành hình tròn
                      color: Colors.white, // Màu nền của container
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 45, // Bán kính của hình tròn
                        backgroundImage: AssetImage(
                            'assets/images/garden_logo.png'), // Hình ảnh logo
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: "SignIn",
                    onTap: signUserIn,
                  ),

                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ))
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Google sign-in button
                  GestureDetector(
                    onTap: signInWithGoogle, // Call the sign-in method
                    child: SquareTile(imagePath: 'assets/images/google.png'),
                  ),
                  const SizedBox(height: 50),
                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                  // ... (your existing code)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

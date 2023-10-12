import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterFace extends StatefulWidget {
  const RegisterFace({Key? key}) : super(key: key);

  @override
  State<RegisterFace> createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              Text("data")
            ],
          )
        ],
      )
    );
  }
}

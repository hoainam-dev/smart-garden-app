import 'package:flutter/cupertino.dart';

Widget Slide () {
  return PageView(
    children: [
      Container(
        width: 366,
        height: 150,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage("https://images.pexels.com/photos/1055408/pexels-photo-1055408.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=10"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0x0006492C), Color(0x1906492C)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      Container(
        width: 366,
        height: 150,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage("https://images.pexels.com/photos/1055408/pexels-photo-1055408.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=10"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0x0006492C), Color(0x1906492C)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      Container(
        width: 366,
        height: 150,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage("https://images.pexels.com/photos/1055408/pexels-photo-1055408.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=10"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0x0006492C), Color(0x1906492C)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

      ),
    ],
  );

}
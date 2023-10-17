import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget Carouse () {
  List items = ["assets/images/slide1.jpg" , "assets/images/slide2.jpg" , "assets/images/slide3.jpg"];
  return
    Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: CarouselSlider(
            options: CarouselOptions(height: 800.0),
            items: items.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                      image: DecorationImage(
                        image: AssetImage(item),
                        fit: BoxFit.cover,
                      ),
                      boxShadow:  [
                        BoxShadow(
                          color: Color(0x1F0C9359),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Positioned(
          left: 42,
          top: 140,
          child: SizedBox(
            width: 300,
            height: 85,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 304,
                    height: 85,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows:  [
                        BoxShadow(
                          color: Color(0x1F0C9359),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  left: 16,
                  top: 20,
                  child: SizedBox(
                    width: 156,
                    height: 25,
                    child: Text(
                      'Team3’s Garden',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 21,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 256,
                  top: 26,
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Opacity(
                            opacity: 0.05,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const ShapeDecoration(
                                color: Color(0xFF0C9359),
                                shape: CircleBorder(),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4,
                          top: 4,
                          child: Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: Stack(children: const [
                              Icon(Icons.add_circle_outline),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  left: 16,
                  top: 53,
                  child: Opacity(
                    opacity: 0.50,
                    child: Text(
                      'ID: 1344295024',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
}

Widget Nutirient({
  required name,
  required icon ,
  required title,
  required icon2,
  required title2 }) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 5),
    child: Container(
      width: 236,
      height: 114,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x1F0C9359),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 15, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "$name",
              style: TextStyle(
                color: Color(0xBF06492C),
                fontSize: 14,
                fontFamily: 'Proxima Nova Alt',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      '$icon',
                    ),
                    SizedBox(width: 20,),
                    Text(
                      '$title',
                      style: TextStyle(
                        color: Color(0xFF06492C),
                        fontSize: 16,
                        fontFamily: 'Proxima Nova Alt',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SvgPicture.asset(
                      '$icon2',
                    ),
                    SizedBox(width: 20,),
                    Text(
                      '$title2',
                      style: TextStyle(
                        color: Color(0xFF06492C),
                        fontSize: 16,
                        fontFamily: 'Proxima Nova Alt',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
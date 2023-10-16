import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Home extends StatefulWidget {
const Home({Key? key}) : super(key: key);
  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // String? temperatureValue;
  // String? humidityValue;
  // String? soilMoistureValue;
  // int Smoisture = 40 ;
  // double SmoistureValue = 0 ;
  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }
  //
  // Future<void> fetchData() async {
  //   QuerySnapshot querySnapshot = await _firestore.collection('sensors').get();
  //
  //   querySnapshot.docs.forEach((doc) {
  //     final topic = doc['topic'];
  //     final value = doc['value'];
  //
  //     if (topic == 'Temp') {
  //       temperatureValue = value;
  //     } else if (topic == 'Humi') {
  //       humidityValue = value;
  //     } else if (topic == 'Smoisture') {
  //       soilMoistureValue = value;
  //     }
  //   });
  //
  //   // Cập nhật UI nếu cần thiết
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // Smoisture = int.parse(soilMoistureValue!);
    // print(Smoisture);
    // setState(() {
    //   // Cập nhật giá trị SmoistureValue
    //   SmoistureValue = 100 - (((4095 - Smoisture) / 4095) * 100);
    // });
    return  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           Center(
             child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1.5,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(color: Color(0xFFF5FDFB)),
              child: Stack(
                children: [
                  Positioned(
                    left: 24,
                    top: 137,
                    child: Container(
                      width: 366,
                      height: 216,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://images.pexels.com/photos/1055408/pexels-photo-1055408.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=10"),
                          fit:BoxFit.cover,
                        ) ,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  
                  //logout 
                  
                  Positioned(
                right: 16,
                top: 16,
                child: IconButton(
                  onPressed: signUserOut,
                  icon: Icon(Icons.logout),
                ),
              ),
                  Positioned(
                    left: 55,
                    top: 297,
                    child: Container(
                      width: 304,
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
                                shadows: [
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
                          Positioned(
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
                            child: Container(
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
                                        decoration: ShapeDecoration(
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
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        Icon(Icons.add_circle_outline),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
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
                  Positioned(
                    left: 177,
                    top: 402,
                    child: Container(
                      width: 60,
                      height: 6,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 6,
                              decoration: ShapeDecoration(
                                color: Color(0x260C9359),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 22,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 6,
                              decoration: ShapeDecoration(
                                color: Color(0xFF0C9359),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 44,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 6,
                              decoration: ShapeDecoration(
                                color: Color(0x260C9359),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 24,
                    top: 64,
                    child: Text(
                      'Hello, Team 3 🌿',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 32,
                        fontFamily: 'Noe Display',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 350,
                    top: 64,
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Opacity(
                              opacity: 0.05,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF0C9359),
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              width: 24,
                              height: 24,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [
                                SvgPicture.asset('assets/svg/setting.svg',)
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 440,
                    child: Container(
                      width: 114,
                      height: 114,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 114,
                              height: 114,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: [
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
                          Positioned(
                            left: 12,
                            top: 56,
                            child: Text(
                              'Temperature',
                              style: TextStyle(
                                color: Color(0xBF06492C),
                                fontSize: 14,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 84,
                            child: Text(
                              '23°c',
                              style: TextStyle(
                                color: Color(0xFF06492C),
                                fontSize: 16,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 16,
                            child: Container(
                              width: 24,
                              height: 24,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [
                                SvgPicture.asset('assets/svg/Temp.svg')
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 272,
                    top: 440,
                    child: Container(
                      width: 114,
                      height: 114,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 114,
                              height: 114,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: [
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
                          Positioned(
                            left: 12,
                            top: 56,
                            child: Text(
                              'Water Level',
                              style: TextStyle(
                                color: Color(0xBF06492C),
                                fontSize: 14,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 84,
                            child: Text(
                              '85%',
                              style: TextStyle(
                                color: Color(0xFF06492C),
                                fontSize: 16,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 16,
                            child: Container(
                              width: 24,
                              height: 24,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [
                                SvgPicture.asset('assets/svg/water.svg')
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    top: 440,
                    child: Container(
                      width: 114,
                      height: 114,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x1F0C9359),
                            blurRadius: 24,
                            offset: Offset(0, 8),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 12,
                            top: 56,
                            child: Text(
                              'Humidity',
                              style: TextStyle(
                                color: Color(0xBF06492C),
                                fontSize: 14,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 84,
                            child: Text(
                              '74%',
                              style: TextStyle(
                                color: Color(0xFF06492C),
                                fontSize: 16,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 16,
                            child: Container(
                              width: 24,
                              height: 24,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [
                                SvgPicture.asset('assets/svg/Frame.svg',)
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    top: 562,
                    child: Container(
                      width: 114,
                      height: 114,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 114,
                              height: 114,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: [
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
                          Positioned(
                            left: 12,
                            top: 56,
                            child: Text(
                              'Connectivity',
                              style: TextStyle(
                                color: Color(0xBF06492C),
                                fontSize: 14,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 84,
                            child: Text(
                              'Online',
                              style: TextStyle(
                                color: Color(0xFF06492C),
                                fontSize: 16,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 16,
                            child: Container(
                              width: 24,
                              height: 24,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [
                                SvgPicture.asset('assets/svg/wifi.svg',)
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 562,
                    child: Container(
                      width: 236,
                      height: 114,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 236,
                              height: 114,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: [
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
                          Positioned(
                            left: 12,
                            top: 12,
                            child: Text(
                              'Nutrient Level',
                              style: TextStyle(
                                color: Color(0xBF06492C),
                                fontSize: 14,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 42,
                            child: Container(
                              width: 120,
                              height: 24,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 32,
                                    top: 3,
                                    child: Text(
                                      '5 grams left',
                                      style: TextStyle(
                                        color: Color(0xFF06492C),
                                        fontSize: 16,
                                        fontFamily: 'Proxima Nova Alt',
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset('assets/svg/clock.svg',),
                                          SvgPicture.asset('assets/svg/tree.svg',)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 78,
                            child: Container(
                              width: 141,
                              height: 24,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 32,
                                    top: 3,
                                    child: Text(
                                      'Refill in 2 days',
                                      style: TextStyle(
                                        color: Color(0xFF06492C),
                                        fontSize: 16,
                                        fontFamily: 'Proxima Nova Alt',
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset('assets/svg/tree.svg',)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    top: 684,
                    child: Container(
                      width: 236,
                      height: 114,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 236,
                              height: 114,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: [
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
                          Positioned(
                            left: 12,
                            top: 12,
                            child: Text(
                              'Status',
                              style: TextStyle(
                                color: Color(0xBF06492C),
                                fontSize: 14,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 44,
                            top: 45,
                            child: Text(
                              '6 plants growing',
                              style: TextStyle(
                                color: Color(0xFF06492C),
                                fontSize: 16,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 44,
                            top: 81,
                            child: Text(
                              'Next harvest in 3 days',
                              style: TextStyle(
                                color: Color(0xFF06492C),
                                fontSize: 16,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 42,
                            child: Container(
                              width: 24,
                              height: 24,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [
                                SvgPicture.asset('assets/svg/tree1.svg',)
                              ]),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 78,
                            child: Container(
                              width: 24,
                              height: 24,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [
                                SvgPicture.asset('assets/svg/clock1.svg',)
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 272,
                    top: 684,
                    child: Container(
                      width: 114,
                      height: 114,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 114,
                              height: 114,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: [
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
                          Positioned(
                            left: 12,
                            top: 56,
                            child: Text(
                              'Light Status',
                              style: TextStyle(
                                color: Color(0xBF06492C),
                                fontSize: 14,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 84,
                            child: Text(
                              'On',
                              style: TextStyle(
                                color: Color(0xFF06492C),
                                fontSize: 16,
                                fontFamily: 'Proxima Nova Alt',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 16,
                            child: Container(
                              width: 24,
                              height: 24,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [
                                SvgPicture.asset('assets/svg/light.svg',)
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
           ),
          ],
        ),
    );

  }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/screens/PlantScreen.dart';

class ResultCheck extends StatefulWidget {
  const ResultCheck({Key? key}) : super(key: key);

  @override
  State<ResultCheck> createState() => _ResultCheckState();
}

class _ResultCheckState extends State<ResultCheck> {
  bool showDetails = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Result'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.of(context).pop(
                MaterialPageRoute(
                  builder: (ctx) => PlantScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body:  Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://landotbien.net/wp-content/uploads/2022/11/hinh-anh-cay-xanh-mam-non-cho-dien-thoai-2-inkythuatso-01-10-48-06.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 250,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 5,
                              offset: Offset(-5, 10),
                            ),
                          ],
                          image: DecorationImage(
                            filterQuality: FilterQuality.high,
                            image: NetworkImage("https://img3.thuthuatphanmem.vn/uploads/2019/06/08/anh-nen-la-cay-va-giot-nuoc_125620128.jpg"), // Đặt đường dẫn đến hình ảnh nền
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        child :Card(
                          elevation: 4.0,
                          margin: EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              // Phần bên trái (Tiêu đề và Mô tả)
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Tiêu đề',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Mô tả chi tiết về thẻ này.',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            showDetails = !showDetails;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              showDetails ? 'Ẩn chi tiết' : 'Xem chi tiết',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Phần bên phải (Hình ảnh)
                              // Phần bên phải (Hình ảnh)
                              Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://i.etsystatic.com/17697018/r/il/d20776/4563534926/il_570xN.4563534926_8wtx.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Nút "Xem chi tiết"
                            ],
                          ),
                        ),
                    ),
                    // Hiển thị chi tiết nếu showDetails là true
                    if (showDetails)
                        Card(
                        elevation: 4.0,
                        margin: EdgeInsets.all(16.0),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent, // Màu nền chat
                            borderRadius: BorderRadius.circular(8.0), // Bo góc
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Hiển thị dòng chữ từ animated_text_kit
                              TypewriterAnimatedTextKit(
                                stopPauseOnTap: true,
                                totalRepeatCount: 1,
                                // onFinished: () {stopPauseOnTap: true},
                                speed: Duration(milliseconds: 100),
                                text: ['Đây là nội dung chi tiết của thẻ.'],
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white, // Màu chữ
                                ),
                                textAlign: TextAlign.start,
                                // alignment: AlignmentDirectional.topStart,
                              ),
                              SizedBox(height: 8.0),
                              // Thời gian hoặc tên người gửi
                              Text(
                                '13:45', // Hoặc tên người gửi
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white70, // Màu thời gian hoặc tên
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ]
              ),
            ),

          ),
        ],
      ),
    );
  }
}

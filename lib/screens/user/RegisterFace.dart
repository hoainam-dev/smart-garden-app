import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_garden_app/models/user.dart';
import 'package:smart_garden_app/service/userService.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

List<CameraDescription>? cameras; //list camera

class RegisterFace extends StatefulWidget {
  const RegisterFace({Key? key}) : super(key: key);

  @override
  State<RegisterFace> createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  // khai bao firebase
  final User? user = FirebaseAuth.instance.currentUser;
  Users? _user;
  List<Users> _users = [];

  CameraController? _controller;
  bool _isCameraReady = false; // camera: tìm thấy | không tìm thấy
  bool _isCameraOn = false; // camera: bật | tắt
  int _currentCamera = 1; // camera: trước | sau

  // lây thông tin user
  void getUser() async{
    final UserService _userService = UserService();
    await _userService.getUserByEmail(user!.email);
    await _userService.getAllUsers();
    _user = _userService.user;
    _users = _userService.users;
  }

  //Init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }


  _initCamera() async {
    cameras = await availableCameras();

    _controller = CameraController(
      cameras![_currentCamera],
      ResolutionPreset.medium,
    );

    await _controller!.initialize();

    setState(() {
      _isCameraReady = true;
      _isCameraOn = true;
    });
  }

  // hàm tắt camera
  _disposeCamera() {
    _controller?.dispose();
    setState(() {
      _isCameraReady = false;
      _isCameraOn = false;
    });
  }

  String getData_api = 'http://127.0.0.1:5000/getdata';
  String training_api = 'http://127.0.0.1:5000/training';

  Future<void> _executeAPI() async {
    int seconds = (_users.length-1)*7+7;
    // http.get(Uri.parse(getData_api));
    Timer(Duration(seconds: seconds), () {
      print("ok da thuc hien");
        // http.get(Uri.parse(training_api));
    });
  }

  //hàm chụp ảnh và xử lý ảnh đã chụp
  _takePicture() async {

    // Tính toán kích thước và vị trí của khung trên ảnh gốc
    int frameWidth = 500; // Chiều rộng của khung
    int frameHeight = 400; // Chiều cao của khung


    for (int i = 0; i < 10; i++) {
      XFile image = await _controller!.takePicture();
      if (image != null) {
        // Đọc ảnh từ tệp đã chụp
        final bytes = File(image.path).readAsBytesSync();
        img.Image? originalImage = img.decodeImage(Uint8List.fromList(bytes));

        int frameX = (originalImage!.width - frameWidth) ~/ 2; // Tọa độ X của khung
        int frameY = (originalImage.height - frameHeight) ~/ 2; // Tọa độ Y của khung

        // Cắt ảnh để chỉ lưu phần nằm trong khung
        img.Image croppedImage = img.copyCrop(originalImage, frameX, frameY, frameWidth, frameHeight);

        // Xoay 90 độ theo chiều kim đồng hồ
        img.Image rotatedImage = img.copyRotate(croppedImage, -90);

        // Lấy đường dẫn tới thư mục chứa assets
        final directory = await getApplicationDocumentsDirectory();
        final imageDirPath = '${directory.path}/${_user!.name}';

        // Tạo thư mục nếu nó chưa tồn tại
        Directory(imageDirPath).createSync(recursive: true);

        //đặt tên cho từng file ảnh
        final imageName = '${_user!.name}.${_user!.faceId}.${i + 1}.jpg';

        // Lưu hình ảnh vào thư mục
        File imageFile = File('$imageDirPath/$imageName');
        imageFile.writeAsBytesSync(img.encodeJpg(rotatedImage, quality: 60));

        uploadImg(_user!.name, imageName, _user!.userId);
      }
    }
    Future.delayed(Duration(seconds: 40), (){
      _executeAPI();
      print("ok");
    });

    //show message thong bao dang ky thanh cong
    _showMessage('Thành công', 'Khuôn mặt đã được đăng ký thành công.',
        'assets/images/success-icon.png');
  }

  //hàm upload ảnh lên firebase storage
  void uploadImg(String name, String imgName, String userId) async {
    // Xác định đường dẫn đến thư mục chứa hình ảnh
    final directory = await getApplicationDocumentsDirectory();
    final imageDirPath = '${directory.path}/$name';

    // Mở thư mục
    final directoryE = Directory(imageDirPath);

    // Liệt kê tất cả các tệp trong thư mục
    List<FileSystemEntity> files = directoryE.listSync();

    // Đọc hoặc xử lý từng tệp trong danh sách `files`
    for (var file in files) {
      if (file is File) {
        // Tải ảnh lên Firebase Storage
        try {
          final Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('faces/$userId/$imgName');
          storageRef.putFile(file);
        } catch (e) {
          print('Lỗi khi tải ảnh lên Firebase Storage: $e');
          _showMessage(
              'Thất bại', 'Không thể đăng ký.', 'assets/images/error-icon.png');
        }
      }
    }
  }

  //hàm show thông báo success | error | warring
  void _showMessage(String title, String content, String imagePath) {
    // Hiển thị thông báo thành công
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            height: 115,
            child: Column(
              children: [
                Image.asset(imagePath, width: 60),
                SizedBox(height: 10),
                Text(content)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _disposeCamera();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  //hàm chuyển camera trước | sau
  switchCamera() {
    setState(() {
      _currentCamera = _currentCamera == 0 ? 1 : 0;
      _initCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Đăng ký khuôn mặt'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          _isCameraReady
              ? Stack(
                  children: <Widget>[
                    CameraPreview(_controller!),
                    Container(
                      margin: EdgeInsets.fromLTRB(55, 120, 55, 0),
                      child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2)),
                          width: 300.0,
                          height: 400.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Text(
                          'Vui lòng đưa mặt vào khung hình giữ yên vài giây',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center),
                    ),
                  ],
                )
              : Container(
                  width: (MediaQuery.of(context).size.width),
                  decoration: const BoxDecoration(color: Color(0xFFF5FDFB)),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/faceId-icon.png', width: 60),

                    ],
                  ),
                ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: _isCameraOn
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                  onPressed: _disposeCamera,
                                  child: Icon(Icons.highlight_off_sharp)),
                              FloatingActionButton(
                                child: Text("Start"),
                                onPressed: _takePicture,
                              ),
                              FloatingActionButton(
                                child: Icon(Icons.flip_camera_ios),
                                onPressed: switchCamera,
                              )
                            ])
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                  onPressed: _initCamera,
                                  child: Icon(Icons.camera_enhance)),
                              FloatingActionButton(
                                  onPressed: _executeAPI,
                                  child: Icon(Icons.ac_unit_outlined)),
                            ],
                          ),
                        ])),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription>? cameras; //list camera

class RegisterFace extends StatefulWidget {
  const RegisterFace({Key? key}) : super(key: key);

  @override
  State<RegisterFace> createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  // khai bao firebase
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  CameraController? _controller;
  bool _isCameraReady = false; // camera: tìm thấy | không tìm thấy
  bool _isCameraOn = false; // camera: bật | tắt
  int _currentCamera = 1; // camera: trước | sau

  _initCamera() async {
    if (_idController.text.isEmpty || _nameController.text.isEmpty) { // check information user
      _showMessage( // if user didn't fill the form -> show message warring
          'Lưu ý',
          'Bạn cần nhập thông tin trước khi đăng ký khuôn mặt.',
          'assets/images/warring-icon.png');
    } else { // else call initCamera function
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
  }

  // hàm tắt camera
  _disposeCamera() {
    _controller?.dispose();
    setState(() {
      _isCameraReady = false;
      _isCameraOn = false;
    });
  }

  //hàm chụp ảnh và xử lý ảnh đã chụp
  _takePicture() async {
    String id = _idController.text;
    String name = _nameController.text;

    // Tính toán kích thước và vị trí của khung trên ảnh gốc
    int frameWidth = 500; // Chiều rộng của khung
    int frameHeight = 400; // Chiều cao của khung

    //lưu thông tin user vào firebase store
    final refUser = await _firestore.collection('users').add({
      'id': id,
      'name': name,
      'timestamp': FieldValue.serverTimestamp(),
    });

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
        final imageDirPath = '${directory.path}/${_nameController.text}';

        // Tạo thư mục nếu nó chưa tồn tại
        Directory(imageDirPath).createSync(recursive: true);

        //đặt tên cho từng file ảnh
        final imageName = '${_nameController.text}.${_idController.text}.${i + 1}.jpg';

        // Lưu hình ảnh vào thư mục
        File imageFile = File('$imageDirPath/$imageName');
        imageFile.writeAsBytesSync(img.encodeJpg(rotatedImage, quality: 60));

        uploadImg(id, name, imageName, refUser.id);
      }
    }


    //set lai form nhap thong tin
    setState(() {
      _idController.text = "";
      _nameController.text = "";
    });

    //show message thong bao dang ky thanh cong
    _showMessage('Thành công', 'Khuôn mặt đã được đăng ký thành công.',
        'assets/images/success-icon.png');
  }

  //hàm upload ảnh lên firebase storage
  void uploadImg(String id, String name, String imgName, String userId) async {
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
                  decoration: const BoxDecoration(color: Color(0xFFF5FDFB)),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/faceId-icon.png', width: 60),
                      const SizedBox(height: 20),
                      const Text("Nhập thông tin",
                          style: TextStyle(fontSize: 25)),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'ID'),
                        controller: _idController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        controller: _nameController,
                      ),
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
                            ],
                          ),
                        ])),
        ],
      ),
    );
  }
}

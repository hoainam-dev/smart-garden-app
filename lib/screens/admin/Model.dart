
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_garden_app/widgets/ChatGpt.dart';
import 'package:tflite/tflite.dart';

enum ImageSourceChoose {
  camera,
  gallery
}

class Model extends StatefulWidget {
  const Model({Key? key}) : super(key: key);

  @override
  State<Model> createState() => _ModelState();
}

class _ModelState extends State<Model> {
  late ImageSourceChoose selectedImageSource;
  late File _image;
  bool setImage = false ;
  List result  = [];
  String output = '';
  CameraController? cameraController;
  CameraImage? cameraImage;
  List<CameraDescription> camera = [];
  // chat bot
  late final TextEditingController promptController;
  String responseTxt = '';

  @override
  void initState()  {
    super.initState(); // Initialize camera
    promptController = TextEditingController();
    camera = <CameraDescription>[];
    loadModel().then((value){
      setState((){
        print(value);

      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    promptController.dispose();
    Tflite.close();
  }
  bool showDetails = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        title: Text("Leaf Detection"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Chọn"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text("Chụp ảnh"),
                          onTap: () {
                            selectedImageSource = ImageSourceChoose.camera;
                            chooseImage();
                            Navigator.pop(context);
                            // tiếp tục xử lý
                          },
                        ),
                        ListTile(
                          title: Text("Chọn từ thư viện"),
                          onTap: () {
                            selectedImageSource = ImageSourceChoose.gallery;
                            chooseImage();
                            Navigator.pop(context);
                            // tiếp tục xử lý
                          },
                        )
                      ],
                    ),
                  );
                }
            );
          }, icon: Icon(Icons.camera))
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
                      child: showDetails == false ? Container(
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
                            image: setImage ? Image.file(_image).image : NetworkImage("https://img3.thuthuatphanmem.vn/uploads/2019/06/08/anh-nen-la-cay-va-giot-nuoc_125620128.jpg"), // Đặt đường dẫn đến hình ảnh nền
                            fit: BoxFit.cover,
                          ),
                        ),
                      ): Container(),
                    ),
                    Container(
                      child :Card(
                        elevation: 4.0,
                        margin: EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            // Phần bên trái (Tiêu đề và Mô tả)
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  result.isNotEmpty?
                                  Text(
                                    result[0]['label']?? '',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ): Text(
                                    "NO RESULT",
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
                      Container(
                        width: MediaQuery.of(context).size.height - 80,
                        height: MediaQuery.of(context).size.height - 300,
                        color: Colors.white,
                        child: ChatGPT(symptom: result[0]['label']?? '',),
                      )
                  ]
              ),
            ),

          ),
        ],
      ),
    )
    );

  }
  bool _isPredicting = false;
  Future<void> chooseImage() async {
    XFile? image ;
    if (selectedImageSource == ImageSourceChoose.camera) {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
      print(selectedImageSource);
    } else {
      print(selectedImageSource);
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    setState(() {
      setImage= true;
      _image = File(image!.path);
    });
    await Future(() async {
      await predictImage(_image);
    });
  }
  loadModel() async {
    await Tflite.loadModel(model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }
  Future<void> predictImage(File image) async {
    if (_isPredicting) return;
    _isPredicting = true;
    var output = await Tflite.runModelOnImage(path: image.path, numResults: 5, threshold: 0.5 , imageMean: 127.5, imageStd: 127.5);
    setState(() {
      result = output!;
    });
    _isPredicting = false;
    print("Result is : $result");
  }
  loadCamera() async {
    camera = await availableCameras();
    if(camera.isNotEmpty) {
      cameraController = CameraController(camera[0], ResolutionPreset.medium);
    }
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      else  {
        setState(() {
          cameraController!.startImageStream((image) {
            cameraImage = image;
            runModel();
          });
        });
      }
    });
  }
  runModel() async {
    if(cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(  asynch: true  , bytesList: cameraImage!.planes.map((plane) {
        return plane.bytes;

      }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 5,
        threshold: 0.1,
      );
      for(var element in predictions! ){
        setState(() {
          output=element['label'];
        });
      }
    }
  }
}

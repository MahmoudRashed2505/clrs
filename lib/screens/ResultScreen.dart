import 'dart:convert';
import 'dart:typed_data';
import 'package:clrs/screens/HomeScreen.dart';
import 'package:clrs/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var _isloading = true;
  final picker = new ImagePicker();
  PickedFile _pickedFile;
  static final String serverIP =
      'http://3.141.103.96:5000/image_processing/grayscale';
  String base64Image;
  String filename;
  RespondFields result;
  var coloredImage;
  var displayedImage;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  void _save(BuildContext context) {
    Uint8List bytes = base64.decode(result.data);
    ImageGallerySaver.saveImage(
      Uint8List.fromList(bytes),
      quality: 60,
      name: result.fileName,
    );
    _showToast(context);
  }

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _isloading = true;
      if (pickedFile != null) {
        _pickedFile = PickedFile(pickedFile.path);
        filename = pickedFile.path.split('/').last;
      } else {
        print("No Image Selected");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    });
    final bytes = await Io.File(pickedFile.path).readAsBytes();
    base64Image = base64.encode(bytes);
    _upload(filename);
  }

  Future<void> _upload(String fileName) async {
    print("Uploading...");
    var body = {"data": base64Image, "filename": fileName};
    var bodyEncoded = json.encode(body);

    final response = await http.post(
      Uri.parse(serverIP),
      body: bodyEncoded,
      headers: {"Content-type": "application/json"},
    );

    result = RespondFields(
      fileName: json.decode(response.body)['filename'],
      base64Image: json.decode(response.body)['data'],
    );
    setState(() {
      coloredImage = base64.decode(result.data);
      displayedImage = coloredImage;
      _isloading = false;
    });
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Photo Saved to Gallery'),
        action: SnackBarAction(
            label: 'DISMISS', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF3c3c3c),
                Color(0xff000000)
              ], // red to yellow
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: _isloading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 80,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isloading = false;
                          });
                        },
                        child: Text(
                          "Please Wait...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Photo is being processed..",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          Uint8List bytes = base64.decode(base64Image);
                          displayedImage = bytes;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          displayedImage = coloredImage;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.memory(
                          displayedImage,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _save(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Save Photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.download_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GradientText(
                                'Colorize',
                              ),
                              Text(
                                "  Another Photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}

class RespondFields {
  final String fileName;
  final String base64Image;
  RespondFields({@required this.fileName, @required this.base64Image});
  String get name => fileName;
  String get data => base64Image;
}

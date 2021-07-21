import 'dart:io';

import 'package:camera/camera.dart';
import 'package:contacts_app/main.dart';
import 'package:contacts_app/modules/scan/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
        cameras[0], ResolutionPreset.medium); // 0 is for back camera
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _takepicture() async {
    if (!_controller.value.isInitialized) {
      print("Controller is not initializes");
      return null;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();
    String formattedDateTime = dateTime.replaceAll(' ', '');
    print("Formatted: $formattedDateTime");

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDr = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDr).create(recursive: true);
    final String imagePath = '$visionDr/image_$formattedDateTime.jpg';

    if (_controller.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }

    try {
      await _controller.takePicture(imagePath);
    } on CameraException catch (e) {
      print("camera exception: $e");
      return null;
    }

    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                CameraPreview(_controller),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async {
                        await _takepicture().then((String path) {
                          if (path != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScanScreen(
                                          image: File(path),
                                        )));
                          }
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Icon(Icons.camera),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Click")
                            ],
                          )),
                    ),
                  ),
                )
              ],
            )
          : null,
    );
  }
}

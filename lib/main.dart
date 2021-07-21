import 'package:camera/camera.dart';
import 'package:contacts_app/modules/overview/overview_screen.dart';
import 'package:flutter/material.dart';

// Global variable for storng the list of cameras availabel
List<CameraDescription> cameras = [];
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OverviewScreen(),
    );
  }
}

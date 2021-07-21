import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:contacts_app/modules/config/api/firebase_ml_api.dart';
import 'package:contacts_app/modules/config/helper/constants.dart';
import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key key, this.image}) : super(key: key);
  final File image;

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File image;
  String result = 'Loading..';
  List<String> contactInfo = [];

  scanText() async {
    final text = await FirebaseMLApi.recogniseText(image);
    setText(text);
  }

  setText(String newText) {
    setState(() {
      result = newText;
      contactInfo = result.split("\n");
      print(contactInfo);
    });
  }

  @override
  void initState() {
    super.initState();
    image = widget.image;
    setState(() {
      scanText();
      print(contactInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                // alignment: Alignment.center,
                child: Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.white,
            )),
          ),
          title: Container(
            padding: EdgeInsets.only(right: 25),
            alignment: Alignment.center,
            child: Text(
              "Add Contact",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          backgroundColor: Constants.kPrimaryColor,
          elevation: 0,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Constants.kPrimaryColor,
          child: GestureDetector(
            onTap: () {
              print("add contact");
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                height: 250,
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          image,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
              ),
              Text(result),
              SizedBox(
                height: 20,
              ),
              // Text(contactInfo[0])
              // Text(contactInfo[0])
            ],
          ),
        ),
      ),
    );
  }
}

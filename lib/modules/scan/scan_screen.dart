import 'dart:io';

import 'package:contacts_app/modules/config/helper/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key key, this.image}) : super(key: key);
  final File image;

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
        body: Container(
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
      ),
    );
  }
}

import 'package:contacts_app/modules/overview/model/contact_model.dart';
import 'package:contacts_app/modules/overview/overview_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OverviewScreen(title: 'Flutter Contacts'),
    );
  }
}

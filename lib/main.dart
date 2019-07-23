import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/CreateAccount.dart';
import 'package:myapp/DashBoard.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register' : (BuildContext context) => CreateAccountPage(),


      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  HomePage(),

    );
  }
}












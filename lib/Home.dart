import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/Animations.dart';
import 'package:myapp/ClassRegister.dart';
import 'package:myapp/CreateAccount.dart';
import 'package:myapp/CreateClass.dart';
import 'package:myapp/DashBoard.dart';
import 'package:myapp/Login.dart';
import 'package:myapp/PersonalPlanner.dart';
import 'package:myapp/UniversalPlanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var currentUser;
  var userEmail = '';

  void initState() {
    final Future<FirebaseUser> futureUser =
        FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        currentUser = user;
        if (user != null) {
          userEmail = user.email;
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(""),
              accountEmail: Text("${userEmail}"),
              currentAccountPicture: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent,
                    radius: 35,
                    child: Text(
                      "L",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    )),
              ),
            ),
            ListTile(
              title: Text("Home"),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              title: Text("Dashboard"),
              trailing: Icon(Icons.dashboard),
              onTap: () {
                if (currentUser != null) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DashBoardPage(user: currentUser)));
                } else {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Please Login First",
                    desc:
                        "You need to be logged into to access your dashboard.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                }
              },
            ),
            ListTile(
              title: Text("Class Registration"),
              trailing: Icon(Icons.class_),
              onTap: () {

                if(currentUser != null){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ClassRegistrationPage(user: currentUser)));
                }
                else{
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Please Login First",
                    desc: "You need to be logged into to register for a class.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                }

              },
            ),
            ListTile(
              title: Text("Create Class"),
              trailing: Icon(Icons.create),
              onTap: () {

                if(currentUser != null){

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CreateClassPage(user: currentUser)));
                }
                else{
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Please Login First",
                    desc: "You need to be logged into to create a class.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                }           },
            ),
            ListTile(
              title: Text("Personal Planner"),
              trailing: Icon(Icons.create),
              onTap: () {

                if(currentUser != null){

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PersonalPlannerPage(user: currentUser)));
                }
                else{
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Please Login First",
                    desc: "You need to be logged into to create a class.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                }           },
            ),
            ListTile(
              title: Text("Universal Planner"),
              trailing: Icon(Icons.create),
              onTap: () {

                if(currentUser != null){

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UniversalPlannerPage(user: currentUser)));
                }
                else{
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Please Login First",
                    desc: "You need to be logged into to create a class.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                }           },
            ),
            ListTile(
              title: Text("Login"),
              trailing: Icon(Icons.person),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            ListTile(
              title: Text("Create Acount"),
              trailing: Icon(Icons.person_add),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Sign Out"),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                setState(() {
                  FirebaseAuth.instance.signOut().then((val) {
                    currentUser = null;
                    userEmail = '';
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  });
                });

              },
            ),
            ListTile(
              title: Text("Close"),
              trailing: Icon(Icons.close),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text("Home")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backpic.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
              child: FadeIn(
                duration: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text(
                  "WELCOME TO",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                Text(
                  "SCHOOLBOARD",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                Text(
                  "CONNECTING",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
            Text(
            "STUDENTS",
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
                Text(
                  "TO TEACHERS",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                )
            ],
          ),
              )),
        ),
      ),
    );
  }
}

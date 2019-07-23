import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/CreateAccount.dart';
import 'package:myapp/CreateClass.dart';
import 'package:myapp/DashBoard.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ClassRegistrationPage extends StatefulWidget {
  @override
  final FirebaseUser user;

  const ClassRegistrationPage({@required this.user});

  _ClassRegistrationPageState createState() => _ClassRegistrationPageState();
}

class _ClassRegistrationPageState extends State<ClassRegistrationPage> {
  @override

  var _class;
  var currentUser;
  var userEmail = '';
  GlobalKey<FormState> _formKeyClassRegistration;
  void initState() {
    _formKeyClassRegistration = GlobalKey<FormState>();
    final Future<FirebaseUser> futureUser =
        FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        currentUser = user;
        if(user != null) {
          userEmail = user.email;
        }
      });
    });
  }

  Widget build(BuildContext context) {

    final classField = TextFormField(
      obscureText: false,
      validator: (value) {


        if (value == null || value.trim() == '') {
          return 'Please enter a class key.';
        }
        _class = value;
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'Class Key',
      ),
    );
    final registerClassButon = DialogButton(
        color: Colors.blue[800],
        child: Text(
          "REGISTER FOR CLASS",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async {
          if (_formKeyClassRegistration.currentState.validate()) {
            _formKeyClassRegistration.currentState.save();

            print("$_class");
            try {
              Firestore.instance.collection('Classes').document(_class).snapshots().listen((doc){
                if(doc.exists) {
                  Firestore.instance
                      .collection('Enrollments')
                      .add({
                    'class_id':_class,
                    'class_name': doc.data['class_name'],
                    'email':widget.user.email
                  }).then((val){
                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Successful Registration",
                      desc: "You have been registered for the ${doc.data['class_name']} class.",
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

                  });
                }
                else{
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Invalid Class Key",
                    desc: "There was no class corresponding to that class key.",
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
              });


            } catch (e) {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Invalid Login",
                    desc: "Your email or password was incorrect.",
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
              } on SocketException catch (_) {
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "No Internet Connection",
                  desc: "You are not connected to the internet.",
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
            }
          }
        });

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
                setState(() {
                  _formKeyClassRegistration = null;
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              title: Text("Dashboard"),
              trailing: Icon(Icons.dashboard),
              onTap: () {

                if(currentUser != null){
                  setState(() {
                    _formKeyClassRegistration = null;
                  });
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => DashBoardPage(user: currentUser)));
                }
                else{
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Please Login First",
                    desc: "You need to be logged into to access your dashboard.",
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
                  setState(() {
                    _formKeyClassRegistration = null;
                  });
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
                  setState(() {
                    _formKeyClassRegistration = null;
                  });
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
                }},
            ),
            ListTile(
              title: Text("Login"),
              trailing: Icon(Icons.person),
              onTap: () {
                setState(() {
                  _formKeyClassRegistration = null;
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            ListTile(
              title: Text("Create Acount"),
              trailing: Icon(Icons.person_add),
              onTap: () {
                setState(() {
                  _formKeyClassRegistration = null;
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CreateAccountPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Sign Out"),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                setState(() {
                  FirebaseAuth.instance.signOut().then((val){
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
                setState(() {
                  _formKeyClassRegistration = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            "SchoolBoard",
            style: TextStyle(fontSize: 30),
          ),
        ), //Text
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backpic.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 0, 35, 0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKeyClassRegistration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircleAvatar(
                          radius: 85,
                          backgroundColor: Colors.blue[800],
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            child: Container(
                                height: 85,
                                child: Image.asset("images/logo.png")),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.0),
                      classField,
                      SizedBox(
                        height: 35.0,
                      ),
                      registerClassButon,
                      SizedBox(
                        height: 15.0,
                      ),
                      InkWell(
                        child: Text(
                          "Create an Account",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          setState(() {
                            _formKeyClassRegistration = null;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccountPage()));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

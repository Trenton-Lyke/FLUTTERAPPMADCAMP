import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/ClassRegister.dart';
import 'package:myapp/ClassesCreated.dart';
import 'package:myapp/CreateClass.dart';
import 'package:myapp/DashBoard.dart';
import 'package:myapp/Enrollments.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/Login.dart';
import 'package:myapp/PersonalPlanner.dart';
import 'package:myapp/UniversalPlanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  var _email;
  var _password;
  var currentUser;
  var userEmail = '';
  GlobalKey<FormState> _formKeyRegister;
  void initState() {
    _formKeyRegister = GlobalKey<FormState>();
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

    final emailField = TextFormField(

      validator: (value) {
        RegExp validEmail = new RegExp("^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");
        Iterable<Match> matches = validEmail.allMatches(value);
        if (matches.length == 0) {
          return 'Please enter a valid email';
        }

        return null;
      },
      onSaved: (value){
        _email = value;
      },


      obscureText: false,

      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,

        labelText: 'Email',
      ),
    );
    final passwordField = TextFormField(
      obscureText: true,

      validator: (value) {
        RegExp validPassword = new RegExp("(?=^.{8,}\$)((?=.*[A-Z])|(?=.*[a-z]))(?=.*[0-9])");
        Iterable<Match> matches = validPassword.allMatches(value);
        if (matches.length == 0) {
          return 'Must be at least 8 characters: letters & numbers.';
        }

        return null;
      },
      onSaved: (value){
        _password = value;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,

        labelText: 'Password',
      ),
    );
    final registerButton = DialogButton(
        color: Colors.blue[800],
        child: Text(
          "CREATE ACCOUNT",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async {
          if (_formKeyRegister.currentState.validate()) {
            _formKeyRegister.currentState.save();
            print("$_email $_password");
            try {
              FirebaseUser user = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: _email, password: _password,);
              user.sendEmailVerification();
              setState(() {
                _formKeyRegister = null;
              });
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => HomePage()));
            }
            catch(e){
              print("hi");
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Invalid or Taken Email or Password",
                    desc: "Your email or password was invalid or taken.",
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

        }
    );



    return
      Scaffold(

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
                    _formKeyRegister = null;
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
                      _formKeyRegister = null;
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
                      _formKeyRegister = null;
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
                      _formKeyRegister = null;
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
                  }  },
              ),
              ListTile(
                title: Text("Personal Planner"),
                trailing: Icon(Icons.create),
                onTap: () {

                  if(currentUser != null){
                    setState(() {
                      _formKeyRegister = null;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => PersonalPlannerPage(user: currentUser)));
                  }
                  else{
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Please Login First",
                      desc: "You need to be logged into to access your personal planner.",
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
                    setState(() {
                      _formKeyRegister = null;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => UniversalPlannerPage(user: currentUser)));
                  }
                  else{
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Please Login First",
                      desc: "You need to be logged into to access the universal planner.",
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
                title: Text("Classes Owned"),
                trailing: Icon(Icons.create),
                onTap: () {

                  if(currentUser != null){
                    setState(() {
                      _formKeyRegister = null;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ClassesCreatedPage(user: currentUser)));
                  }
                  else{
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Please Login First",
                      desc: "You need to be logged in to access the classes you own.",
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
                title: Text("Enrollments"),
                trailing: Icon(Icons.create),
                onTap: () {

                  if(currentUser != null){
                    setState(() {
                      _formKeyRegister = null;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => EnrollmentsPage(user: currentUser)));
                  }
                  else{
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Please Login First",
                      desc: "You need to be logged in to access the classes your enrollments enrolled.",
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
                  setState(() {
                    _formKeyRegister = null;
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
                    _formKeyRegister = null;
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
                    _formKeyRegister = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Center(child: Text("SchoolBoard",
            style: TextStyle(fontSize: 30),),
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

            child:
            Center(
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0,0,35,0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKeyRegister,
                    child:
                    Column(
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
                        SizedBox(height: 45.0),
                        emailField,
                        SizedBox(height: 25.0),
                        passwordField,
                        SizedBox(
                          height: 35.0,
                        ),
                        registerButton,
                        SizedBox(
                          height: 15.0,
                        ),
                        InkWell(
                          child: Text("Login", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),),
                          onTap: (){
                            setState(() {
                              _formKeyRegister = null;
                            });
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => LoginPage()));
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




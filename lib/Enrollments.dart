import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/Animations.dart';
import 'package:myapp/ClassAnswersForTeacher.dart';
import 'package:myapp/ClassForStudent.dart';
import 'package:myapp/ClassForTeacher.dart';
import 'package:myapp/ClassRegister.dart';
import 'package:myapp/CreateAccount.dart';
import 'package:myapp/CreateClass.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/Login.dart';
import 'package:myapp/QuestionBuilder.dart';
import 'package:myapp/functions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';

class DashBoardPage extends StatefulWidget {
  @override
  final FirebaseUser user;
  DashBoardPage({@required this.user});
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override

  final CollectionReference Classes = Firestore.instance.collection("Classes");

  var currentUser;
  var userEmail = '';

  void initState() {

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
  @override
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

                if(currentUser != null){
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

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Dash Board"),
        actions: <Widget>[IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () {



            })],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Enrollments")
                      .where("email", isEqualTo: widget.user.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.documents.length == 0) {
                      return Text("Loading...");
                    } else {
                      var cardList = List<Widget>();
                      cardList.add(Text("ENROLLMENTS"),);
                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                        cardList.add(Card(
                          child:
                          Column(
                              children: <Widget>[

                                Text("${snapshot.data.documents[i]["class_name"]}"),
                                InkWell(
                                  child: Text("Questions for Teacher Stream", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),),
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) => ClassStudentQuestionsPage(classDoc : snapshot.data.documents[i])));
                                  },

                                ),
                                InkWell(
                                  child: Text("Questions for Student Stream", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),),
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) => ClassTeacherQuestionsPage(classDoc : snapshot.data.documents[i])));
                                  },

                                ),
                                InkWell(
                                  child: Text("Answers for Teacher Stream", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),),
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) => ClassStudentAnswersPage(classDoc : snapshot.data.documents[i])));
                                  },

                                ),
                                InkWell(
                                  child: Text("Question Builder for Teacher", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),),
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) => QuestionBuilderPage(classDoc : snapshot.data.documents[i])));
                                  },

                                ),

                              ]),
                        )
                        );
                      }
                      print(cardList);
                      return Column(
                        children: cardList,
                      );
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}



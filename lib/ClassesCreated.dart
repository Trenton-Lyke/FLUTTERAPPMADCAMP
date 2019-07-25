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
import 'package:myapp/Enrollments.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/Login.dart';
import 'package:myapp/PersonalPlanner.dart';
import 'package:myapp/QuestionBuilder.dart';
import 'package:myapp/UniversalPlanner.dart';
import 'package:myapp/functions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class ClassesCreatedPage extends StatefulWidget {
  @override
  final FirebaseUser user;
  ClassesCreatedPage({@required this.user});
  _ClassesCreatedPageState createState() => _ClassesCreatedPageState();
}

class _ClassesCreatedPageState extends State<ClassesCreatedPage> {
  @override

  final CollectionReference Classes = Firestore.instance.collection("Classes");

  var currentUser;
  var userEmail = '';
  var key = GlobalKey<ScaffoldState>();
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
      key:key,
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
                  key = null;
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
                    key = null;
                  });
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ClassesCreatedPage(user: currentUser)));
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
                    key = null;
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
                    key = null;
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
                }           },
            ),
            ListTile(
              title: Text("Personal Planner"),
              trailing: Icon(Icons.create),
              onTap: () {

                if(currentUser != null){
                  setState(() {
                    key = null;
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
                    key = null;
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
                    key = null;
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
                    key = null;
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
                  key = null;
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
                  key = null;
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
                    key = null;

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backpic.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection("Classes")
                        .where("email", isEqualTo: widget.user.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.documents == 0) {
                        return Text("Loading...");
                      } else {
                        var cardList = List<Widget>();
                        cardList.add(Text("CLASSES CREATED",),);
                        for (int i = 0; i < snapshot.data.documents.length; i++) {
                          cardList.add(Card(
                            child:
                            Column(
                                children: <Widget>[
                                  Text("${snapshot.data.documents[i]["class_name"]}",style: TextStyle(fontSize: 40,
                                  ),),
                                  GestureDetector(
                                      onLongPress: () {
                                        Clipboard.setData(new ClipboardData(text: snapshot.data.documents[i].documentID));
                                        key.currentState.showSnackBar(
                                            new SnackBar(content: new Text("Copied to Clipboard"),));
                                      },
                                      child: Text("CLASS KEY: ${snapshot.data.documents[i].documentID}", style: TextStyle(fontSize: 20),)),

                              InkWell(
                                child: Text("Questions for Teacher Stream", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 20),),
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) => ClassStudentQuestionsPage(class_id : snapshot.data.documents[i].documentID)));
                                },

                              ),

                              InkWell(
                                child: Text("Answers for Teacher Stream", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 20),),
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) => ClassStudentAnswersPage(classDoc : snapshot.data.documents[i])));
                                },

                              ),
                              InkWell(
                                child: Text("Question Builder for Teacher", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 20),),
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
      ),
    );
  }
}



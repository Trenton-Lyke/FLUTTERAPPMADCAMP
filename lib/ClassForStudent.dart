import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/Animations.dart';
import 'package:myapp/ClassRegister.dart';
import 'package:myapp/CreateAccount.dart';
import 'package:myapp/CreateClass.dart';
import 'package:myapp/DashBoard.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/Login.dart';
import 'package:myapp/functions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';

class ClassTeacherQuestionsPage extends StatefulWidget {
  @override
  final DocumentSnapshot classDoc;
  ClassTeacherQuestionsPage({@required this.classDoc});
  _ClassTeacherQuestionsPageState createState() => _ClassTeacherQuestionsPageState();
}

class _ClassTeacherQuestionsPageState extends State<ClassTeacherQuestionsPage> {
  @override

  final CollectionReference Classes = Firestore.instance.collection("Classes");
  var questionAnswers;
  var groupValues;
  var currentUser;
  var userEmail = '';

  @override
  void initState() {
    // TODO: implement initState
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
                }  },
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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                print(widget.classDoc["class_id"]);
              })
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection("ClassTeacherQuestions")
                .where("class_id", isEqualTo: widget.classDoc["class_id"])
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0) {
                print(widget.classDoc["class_id"]);
                return Text("Loading...");
              } else {
                var cardList = List<Widget>();
                print(snapshot.data.documents);

                if(questionAnswers == null){
                  questionAnswers = new List(snapshot.data.documents.length);
                  groupValues = new List(snapshot.data.documents.length);
                  for(int i = 0; i < groupValues.length; i++){
                    print(groupValues[i]);
                    groupValues[i] = -1;

                  }
                }
                else{
                  var temp = questionAnswers;
                  questionAnswers = new List(snapshot.data.documents.length);
                  for(int i =0; i < temp.length; i++){
                    questionAnswers[i]=temp[i];
                  }
                }
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  Widget answer = Container();
                  if (snapshot.data.documents[i]["type"] == "radio") {
                    answer = Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Radio(
                              value:0,
                              groupValue: groupValues[i],
                              onChanged: (dynamic) {
                                setState((){
                                  questionAnswers[i] = snapshot.data.documents[i]["answers"]["a"];
                                  groupValues[i] = dynamic;
                                });

                              }),
                          Text(snapshot.data.documents[i]["answers"]["a"]),
                          Radio(
                              value: 1,
                              groupValue: groupValues[i],
                              onChanged: (dynamic) {
                                setState((){
                                  questionAnswers[i] = snapshot.data.documents[i]["answers"]["b"];
                                  groupValues[i] = dynamic;
                                });

                              }),
                          Text(snapshot.data.documents[i]["answers"]["b"]),
                          Radio(
                              value: 2,
                              groupValue: groupValues[i],
                              onChanged: (dynamic) {
                                setState((){
                                  questionAnswers[i] = snapshot.data.documents[i]["answers"]["c"];
                                  groupValues[i] = dynamic;
                                });

                              }),
                          Text(snapshot.data.documents[i]["answers"]["c"]),
                          Radio(
                              value: 3,
                              groupValue: groupValues[i],
                              onChanged: (dynamic) {
                                setState((){
                                  questionAnswers[i] = snapshot.data.documents[i]["answers"]["d"];
                                  groupValues[i] = dynamic;
                                });

                              }),
                          Text(snapshot.data.documents[i]["answers"]["d"]),
                        ]),
                      DialogButton(child: Text("Submit"), onPressed: () {
                        if(questionAnswers[i] != null){
                        Firestore.instance
                            .collection("StudentAnswers").add({'answer': questionAnswers[i], 'class_id': widget.classDoc["class_id"], 'type':'radio', 'question': snapshot.data.documents[i]['question'], 'question_id': snapshot.data.documents[i].documentID});
                      }})],
                    );
                  }
                  if (snapshot.data.documents[i]["type"] == "text") {
                    answer = Column(
                      children: <Widget>[
                        TextField(

                        onSubmitted: (value){
                      questionAnswers[i] = value;
                    },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,

                            labelText: 'Answer',
                          ),
                    ),
                        DialogButton(child: Text("Submit"), onPressed: () {
    if(questionAnswers[i] != null && questionAnswers[i].trim() != ''){
                          Firestore.instance
                              .collection("StudentAnswers").add({'answer': questionAnswers[i], 'class_id': widget.classDoc["class_id"], 'type':'text', 'question': snapshot.data.documents[i]['question'], 'question_id': snapshot.data.documents[i].documentID});
                        }})],
                    );
                  }
                  cardList.add(
                    Card(
                      child: Column(
                        children: <Widget>[
                          Text("${snapshot.data.documents[i]["question"]}"),
                          answer,
                        ],
                      ),
                    ),
                  );
                }
                print(cardList);
                return Column(
                  children: cardList,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}




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
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'dart:core';

class ClassStudentAnswersPage extends StatefulWidget {
  @override
  final DocumentSnapshot classDoc;
  ClassStudentAnswersPage({@required this.classDoc});
  _ClassStudentAnswersPageState createState() => _ClassStudentAnswersPageState();
}

class _ClassStudentAnswersPageState extends State<ClassStudentAnswersPage> {
  @override
  final CollectionReference Classes = Firestore.instance.collection("Classes");

  var currentUser;
  var userEmail = '';

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
                }},
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
              print(widget.classDoc["class_id"]);


            })],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection("StudentAnswers")
                .where("class_id", isEqualTo: widget.classDoc["class_id"])
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0) {
                print(widget.classDoc["class_id"]);
                return Text("Loading...");
              } else {
                var cardList = List<Widget>();
                print(snapshot.data.documents);
                var question_list = new List();
                var isUnique = true;
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  for(int j = 0; j <question_list.length; j++){

                    if(snapshot.data.documents[i]['question_id']==question_list[j]['question_id']){
                      isUnique = false;
                    }
                  }
                  print(isUnique);
                  if(isUnique){

                    question_list.add({'question_id': snapshot.data.documents[i]['question_id'], 'question': snapshot.data.documents[i]['question'], 'type': snapshot.data.documents[i]['type'], 'answers':new Map(), 'series': new List<charts.Series>(), 'data': new List<Responses>()});
                  }

                }
                for (int i = 0; i < question_list.length; i++) {
                  for (int j = 0; j < snapshot.data.documents.length; j++) {
                    if(question_list[i]["question_id"] == snapshot.data.documents[j]['question_id']){
                      if(question_list[i]['answers'].containsKey(snapshot.data.documents[j]['answer'])) {
                        question_list[i]['answers'].update(snapshot.data.documents[j]['answer'], (value) => value + 1);
                      }
                      else{
                        question_list[i]['answers'][snapshot.data.documents[j]['answer']] = 1;
                      }
                    }
                  }

                }
                var colors = [charts.MaterialPalette.blue.shadeDefault, charts.MaterialPalette.red.shadeDefault, charts.MaterialPalette.yellow.shadeDefault, charts.MaterialPalette.green.shadeDefault, charts.MaterialPalette.deepOrange.shadeDefault, charts.MaterialPalette.purple.shadeDefault];
                for (int i = 0; i < question_list.length; i++) {
                  int k = 0;
                  for(var answer in question_list[i]['answers'].keys){
                    question_list[i]['data'].add(Responses(answer,question_list[i]['answers'][answer],colors[k%6]));
                    k++;
                  }
                  question_list[i]['series'].add(
                      new charts.Series<Responses, String>(
                        id: 'Answers',
                        colorFn: (Responses ans, __) => ans.color,
                        domainFn: (Responses ans, _) => ans.answer,
                        measureFn: (Responses ans, _) => ans.count,
                        data: question_list[i]['data'],

                      )
                  );
                }
                for (int i = 0; i < question_list.length; i++) {



                  cardList.add(Card(child:Column(
                    children: <Widget>[
                      Text("${question_list[i]['question']}"),
                      Container( child: charts.PieChart(question_list[i]['series'], defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [new charts.ArcLabelDecorator()])
                      ), height : 200,
                      )
                    ],
                  )));
                }
                //
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




class Responses{
  final String answer;
  final int count;
  final color;
  Responses(this.answer, this.count, this.color);


}
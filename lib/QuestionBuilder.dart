import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/ClassForStudent.dart';
import 'package:myapp/ClassRegister.dart';
import 'package:myapp/CreateAccount.dart';
import 'package:myapp/CreateClass.dart';
import 'package:myapp/DashBoard.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';



class QuestionBuilderPage extends StatefulWidget {
  @override
  final DocumentSnapshot classDoc;
  QuestionBuilderPage({@required this.classDoc});
  _QuestionBuilderPageState createState() => _QuestionBuilderPageState();
}

class _QuestionBuilderPageState extends State<QuestionBuilderPage> {
  @override
  var question;

  Map<String, String> answers = new Map<String, String>();

  GlobalKey<FormState> _formKeyQuestionBuilder;
  var type;
  var currentUser;
  var userEmail = '';
  void initState() {
    _formKeyQuestionBuilder = GlobalKey<FormState>();
    type = 'radio';
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

    final questionField = TextFormField(

      validator: (value) {

        if (value == null || value.trim() == '') {
          return 'Please enter a question';
        }
        question = value;
        return null;
      },



      obscureText: false,

      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,

        labelText: 'Question',
      ),
    );
    final typeField = Row(children: <Widget>[
      Radio(value: 'radio', groupValue: type, onChanged: (value){
        setState((){
          type = value;
        });

      }),Text("Multiple Choice"),
    Radio(value: 'text', groupValue: type, onChanged: (value){
      setState((){
        type = value;
      });
    }),Text("Short Answer"),
    ],);
    Widget answersFields = Column(children: <Widget>[Row(children: <Widget>[Text("A"),Expanded(
      child: TextFormField(

        validator: (value) {

          if (value == null || value.trim() == '') {
            return 'Please enter an answer';
          }
          answers['a'] = value;
          return null;
        },



        obscureText: false,

        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,

          labelText: 'Answer',
        ),
      ),
    ),SizedBox(
    height: 35.0,
    ),
    ],),

      Row(children: <Widget>[Text("B"), Expanded(
        child: TextFormField(

          validator: (value) {

            if (value == null || value.trim() == '') {
              return 'Please enter an answer';
            }
            answers['b'] = value;
            return null;
          },



          obscureText: false,

          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,

            labelText: 'Answer',
          ),
        ),
      ),SizedBox(
        height: 35.0,
      ),],),

    Row(children: <Widget>[Text("C"), Expanded(
      child: TextFormField(

      validator: (value) {

      if (value == null || value.trim() == '') {
      return 'Please enter an answer';
      }
      answers['c'] = value;
      return null;
      },



      obscureText: false,

      decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,

      labelText: 'Answer',
      ),
      ),
    ),SizedBox(
      height: 35.0,
    ),],),

    Row(children: <Widget>[Text("D"), Expanded(
      child: TextFormField(

      validator: (value) {

      if (value == null || value.trim() == '') {
      return 'Please enter an answer';
      }
      answers['d'] = value;
      return null;
      },



      obscureText: false,

      decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,

      labelText: 'Answer',
      ),
      ),
    ),SizedBox(
      height: 35.0,
    ),],)

    ],);

    if(type == 'text'){
      answersFields = Container();
    }
    final createQuestionButton = DialogButton(
        color: Colors.blue[800],
        child: Text(
          "CREATE QUESTION",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async{
          if (_formKeyQuestionBuilder.currentState.validate()) {
            _formKeyQuestionBuilder.currentState.save();

            print("$question");
            try{
              if(type == 'radio'){
              Firestore.instance
                  .collection("ClassTeacherQuestions").add({
                'question':question,
                'answers':answers,
                'type': type,
                'class_id': widget.classDoc['class_id']
              }
              ).then((val){
                setState(() {
                  _formKeyQuestionBuilder = null;
                });
              });
              }
              else{
                Firestore.instance
                    .collection("ClassTeacherQuestions").add({
                  'question':question,
                  'type': type,
                  'class_id': widget.classDoc['class_id']
                }
                ).then((val){
                  setState(() {
                    _formKeyQuestionBuilder = null;
                  });
                });
              }


              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ClassTeacherQuestionsPage(classDoc: widget.classDoc)));



            }
            catch(e){
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Invalid QuestionBuilder",
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
                    _formKeyQuestionBuilder = null;
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
                      _formKeyQuestionBuilder = null;
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
                      _formKeyQuestionBuilder = null;
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
                      _formKeyQuestionBuilder = null;
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
                    _formKeyQuestionBuilder = null;
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
                    _formKeyQuestionBuilder = null;
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
                    _formKeyQuestionBuilder = null;
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
                    key: _formKeyQuestionBuilder,
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
                        questionField,
                        SizedBox(height: 25.0),
                        typeField,
                        SizedBox(
                          height: 25.0,
                        ),
                        answersFields,
                        SizedBox(
                          height: 35.0,
                        ),
                        createQuestionButton,
                        SizedBox(
                          height: 15.0,
                        ),

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




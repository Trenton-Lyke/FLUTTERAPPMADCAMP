import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:myapp/Calendar.dart';
import 'package:myapp/ClassRegister.dart';
import 'package:myapp/ClassesCreated.dart';
import 'package:myapp/CreateAccount.dart';
import 'package:myapp/CreateClass.dart';
import 'package:myapp/DashBoard.dart';
import 'package:myapp/DateTimePicker.dart';
import 'package:myapp/Enrollments.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/Login.dart';
import 'package:myapp/UniversalPlanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class PersonalPlannerPage extends StatefulWidget {
  @override
final FirebaseUser user;

  const PersonalPlannerPage({@required this.user});





  _PersonalPlannerPageState createState() => _PersonalPlannerPageState();
}

class _PersonalPlannerPageState extends State<PersonalPlannerPage> {
  @override


  var currentUser;
  var userEmail = '';
  Map _events;
  GlobalKey<FormState> _formKeyPersonalPlanner;
  void initState() {
    _formKeyPersonalPlanner = GlobalKey<FormState>();

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
                  _formKeyPersonalPlanner = null;
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
                    _formKeyPersonalPlanner = null;
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
                    _formKeyPersonalPlanner = null;
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
                    _formKeyPersonalPlanner = null;
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
                }
                },
            ),
            ListTile(
              title: Text("Personal Planner"),
              trailing: Icon(Icons.create),
              onTap: () {

                if(currentUser != null){
                  setState(() {
                    _formKeyPersonalPlanner = null;
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
                    _formKeyPersonalPlanner = null;
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
                    _formKeyPersonalPlanner = null;
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
                    _formKeyPersonalPlanner = null;
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
                  _formKeyPersonalPlanner = null;
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
                  _formKeyPersonalPlanner = null;
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
                  _formKeyPersonalPlanner = null;
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
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backpic.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height/10, 0, 0),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 0, 35, 0),
                child:
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
                  height: 6.5*MediaQuery.of(context).size.height/10,

                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("PersonalPlanner")
                        .where("email", isEqualTo: widget.user.email).orderBy('dateTime')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData || snapshot.data.documents.length == 0) {

                        return CalendarScreen(events: {}, withAdder: false, user: widget.user);

                      }
                      else{
                        print(snapshot.data.documents.length);
                        Map<DateTime, List<Map>> events = new Map<DateTime, List<Map>>();
                        for(int i = 0; i < snapshot.data.documents.length; i++){
                          var event_dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.data.documents[i]['dateTime'].seconds*1000);
                          var event_time = formatTime(event_dateTime.hour, event_dateTime.minute);
                          event_dateTime = DateTime(event_dateTime.year, event_dateTime.month, event_dateTime.day);
                          if(events.containsKey(event_dateTime)){
                            events[event_dateTime].add({'name':'$event_time - ${snapshot.data.documents[i]['task']}', 'isDone': false});
                          }
                          else{
                            List<Map> tempList = new List<Map>();
                            tempList.add({'name':'$event_time - ${snapshot.data.documents[i]['task']}', 'isDone': false});
                            events[event_dateTime] = tempList;

                          }

                        }


                        return CalendarScreen(events: events, withAdder: false, user: widget.user,);
                      }
                    }
                  ),
                ),


              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: (){Alert(context: context, title: "Add Task", content:  AlertDTContent(userEmail: widget.user.email)).show();}),
    );

  }


}

class AlertDTContent extends StatefulWidget {
  @override
  final String userEmail;

  const AlertDTContent({@required this.userEmail});

  _AlertDTContentState createState() => _AlertDTContentState();
}

class _AlertDTContentState extends State<AlertDTContent> {
  @override
  var task;
  var date;
  var time;
  DateTime _dateTime;
  var currentUser;
  var userEmail = '';
  Map _events;

  void initState() {
    date = DateTime.now();
    time = TimeOfDay.now();
  }

  Widget build(BuildContext context) {
    final taskField = TextField(
      obscureText: false,
      onChanged: (value){
        task = value;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'Class Name',
      ),
    );


    final dateTimeField = DateTimePicker(selectedDate: date,
      selectedTime: time,
      selectDate: (val){

        setState((){
          date = val;
          time = time;
          print(time);
        });

      }, selectTime: (val){

        setState((){
          time = val;
          date = date;
        });

      },);



    var addEventButon = DialogButton(
        color: Colors.blue[800],
        child: Text(
          "ADD TASK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async {

          _dateTime = new DateTime(date.year, date.month, date.day, time.hour, time.minute);

          print("$task");
          try {
            Firestore.instance.collection('PersonalPlanner').add({'task':task, 'email':widget.userEmail, 'dateTime': _dateTime}).then((val){
              Alert(
                context: context,
                type: AlertType.success,
                title: "Task added",
                desc: "You have updating the personal planner.",
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



          } catch (e) {
            try {
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "There was a problem",
                  desc: "There was a problem adding your task to the universal planner. Please try again later.",
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

        });
    Widget form =
    Form(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 25.0),
          taskField,
          SizedBox(height: 25.0),
          dateTimeField,
          SizedBox(
            height: 50.0,
          ),
          addEventButon,
          SizedBox(
            height: 50.0,
          )

        ],
      ),
    );

    return form;
  }
}

String formatTime(hour, minute){
  String ending;
  String formattedMinutes;

  if("$minute".length == 1){
    formattedMinutes = '$minute'+'0';
  }
  else{
    formattedMinutes = '$minute';
  }

  if(hour%12 == hour){
    ending = "am";
  }
  else{
    ending = "pm";
  }
  if(hour == 12 || hour == 0) {
    return "12:$formattedMinutes $ending";
  }
  else{
    return "${hour % 12}:$formattedMinutes $ending";
  }
}
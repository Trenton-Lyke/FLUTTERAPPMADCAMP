import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CalendarScreen extends StatefulWidget {
  @override
  final Map events;
  final bool withAdder;

  final FirebaseUser user;

  const CalendarScreen({@required this.events, @required this.withAdder, @required this.user});
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = widget.events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List _selectedEvents;
  DateTime _selectedDay;



  @override
  void initState() {
    super.initState();
    _selectedEvents = widget.events[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var eventLister;
    if(widget.withAdder){
      eventLister = _buildEventListWithAdder();
    }
    else{
      eventLister = _buildEventList();
    }
    return
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Calendar(
                  events: widget.events,
                  onRangeSelected: (range) =>
                      print("Range is ${range.from}, ${range.to}"),
                  onDateSelected: (date) => _handleNewDate(date),
                  isExpandable: true,
                  showTodayIcon: true,
                  eventDoneColor: Colors.green,
                  eventColor: Colors.grey),
            ),
            eventLister
          ],
        );
  }

  Widget _buildEventList() {
  return Expanded(
    child: ListView.builder(
      itemBuilder: (BuildContext context, int index) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Colors.black12),
          ),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
        child: ListTile(
          title: Text(_selectedEvents[index]['name'].toString()),
          onTap: () {},
        ),
      ),
      itemCount: _selectedEvents.length,
    ),
  );
}


Widget _buildEventListWithAdder() {
  return Expanded(
    child: ListView.builder(
      itemBuilder: (BuildContext context, int index) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Colors.black12),
          ),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
        child: ListTile(
          title: Text(_selectedEvents[index]['name'].toString()),
          onTap: () {
            Alert(
              context: context,
              type: AlertType.info,
              title: "Add to Personal Planner",
              desc: "Would you like to add this to your personal planner?",
              buttons: [
                DialogButton(
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: (){
                    var document = _selectedEvents[index]['document'];
                    Firestore.instance.collection('PersonalPlanner').add({'task':document['task'], 'email':widget.user.email, 'dateTime':document['dateTime']}).then((val){
                    Navigator.pop(context);
                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Event Added",
                      desc: "The event has been added.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "COOL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                    });

                  },
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                ),
                DialogButton(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                )
              ],
            ).show();
          },
        ),
      ),
      itemCount: _selectedEvents.length,
    ),
  );
}
}
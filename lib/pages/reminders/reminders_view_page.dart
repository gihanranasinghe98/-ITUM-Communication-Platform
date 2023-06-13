import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itum_communication_platform/service/database_service.dart';
import 'package:itum_communication_platform/widgets/reminders_tile.dart';

class RemindersView extends StatefulWidget {
  final String groupId;
  final String admin;
  final String name;
  final String userId;
  const RemindersView({Key? key,
    required this.groupId,
    required this.admin,
    required this.name,
    required this.userId,
  }) : super(key: key);

  @override
  _RemindersViewState createState() => _RemindersViewState();
}

class _RemindersViewState extends State<RemindersView> {
  String title = "";
  String description = "";
  String date ="";
  String time ="";
  Stream<QuerySnapshot>? reminders;

  @override
  void initState() {
    gettingReminders();
    super.initState();
  }

  gettingReminders(){
    DatabaseService().getReminders(widget.groupId).then((val){
      setState(() {
        reminders = val;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF1EDF4),
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)
              ),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xFFA88BEB), Color(0xFFD5ADC8)]),
            ),
          ),
          title: const Text('Reminders', style: TextStyle(color: Colors.white),),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)
              )
          ),
        ),
        body: remindersList()
    );
  }

  remindersList(){
    return StreamBuilder(
      stream: reminders,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData ?
        ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            int reversIndex = snapshot.data.docs.length - index - 1;
            return ReminderTile(
              title : snapshot.data.docs[index]['title'],
              description : snapshot.data.docs[index]['description'],
              dateTime: snapshot.data.docs[index]['dateTime'].toDate().toString(),
                date : formattedDate(snapshot.data.docs[index]['dateTime']),
                time : formattedTime(snapshot.data.docs[index]['dateTime']),
              admin: widget.admin,
              name: widget.name,
              userId: widget.userId,
            );
          },
        )
            : Container();
      },
    );
  }
// noRemindersWidget(){
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 25),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: const [
//         Text("This group haven't got any reminders yet" ,
//           textAlign: TextAlign.center,),
//       ],
//     ),
//   );
// }
  String formattedDate(timeStamp){
    var dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd-MM-yyyy').format(dateFromTimeStamp);
  }
  String formattedTime(timeStamp){
    var dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('hh:mm a').format(dateFromTimeStamp);
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderTile extends StatefulWidget {
  final String title;
  final String description;
  final String dateTime;
  final String date;
  final String time;
  final String admin;
  final String name;
  final String userId;
  const ReminderTile({Key? key,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.date,
    required this.time,
    required this.admin,
    required this.name,
    required this.userId,
  }) : super(key: key);



  @override
  _ReminderTileState createState() => _ReminderTileState();
}

class _ReminderTileState extends State<ReminderTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.only(top: 17, bottom: 17,left: 20, right: 20),
        decoration:  BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0.2,
                  blurRadius: 5,
                  offset: const Offset(0.0, 5.0)
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.edit, color: Color(0xFFbf94e4),),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.delete, color: Color(0xFFb19cd9),),
                    )
                  ],
                )
              ],
            ),

            Text(widget.description,
            style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.black26,),
                    SizedBox(width: 2,),
                    Text(widget.date)
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time,color: Colors.black26),
                    SizedBox(width: 2,),
                    Text(widget.time)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itum_communication_platform/pages/reminders/reminders_view_page.dart';
import 'package:itum_communication_platform/service/database_service.dart';
import 'package:itum_communication_platform/widgets/widegets.dart';
import 'package:lottie/lottie.dart';

class RemindersHome extends StatefulWidget {
  final String groupId;
  final String admin;
  final String userId;
  final String name;
  const RemindersHome({Key? key,
    required this.groupId,
    required this.admin,
    required this.userId,
    required this.name,
  }) : super(key: key);

  @override
  _RemindersHomeState createState() => _RemindersHomeState();
}

class _RemindersHomeState extends State<RemindersHome> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  DateTime dateTime = DateTime.now();


  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

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
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Add Reminders', style: TextStyle(color: Colors.white),),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)
              )
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(

                children: [
                  Lottie.network('https://assets2.lottiefiles.com/packages/lf20_jUBSNSycq9.json',
                    width: 280,
                    height: 250,
                    fit: BoxFit.fill,),
                  TextFormField(
                    controller: _titleController,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Title",
                    ),
                    onChanged: (val){
                      setState(() {
                        title = val;
                      });
                    },
                    validator: (val){
                      if(val!.isNotEmpty){
                        return null;
                      }else{
                        return "Name cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Description",
                    ),
                    onChanged: (val){
                      setState(() {
                        description = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: FocusNode(),
                    enableInteractiveSelection: false,
                    decoration: textInputDecoration.copyWith(
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        hintText: "Set a Date : ${dateTime.year}/${dateTime.month}/${dateTime.day}"
                    ),
                    onTap: ()async{
                      DateTime ? newDate = await showDatePicker(
                          context: context,
                          initialDate: dateTime,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2040),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFFA88BEB),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFFA88BEB),
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Color(0xFFA88BEB), // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if(newDate == null) return ;

                      final newDateTime = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                        dateTime.hour,
                        dateTime.minute,
                      );
                      setState(() => dateTime = newDateTime);
                    },
                  ),
                  // Text('${dateTime.year}/${dateTime.month}/${dateTime.day}'),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // ElevatedButton(
                  //     onPressed: ()async{
                  //       DateTime ? newDate = await showDatePicker(
                  //           context: context,
                  //           initialDate: dateTime,
                  //           firstDate: DateTime(2023),
                  //           lastDate: DateTime(2040)
                  //       );
                  //       if(newDate == null) return ;
                  //
                  //       final newDateTime = DateTime(
                  //         newDate.year,
                  //         newDate.month,
                  //         newDate.day,
                  //         dateTime.hour,
                  //         dateTime.minute,
                  //       );
                  //       setState(() => dateTime = newDateTime);
                  //     },
                  //     child: Text('Select Date')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: FocusNode(),
                    enableInteractiveSelection: false,
                    decoration: textInputDecoration.copyWith(
                        prefixIcon: Icon(Icons.access_time),
                        hintText: "Set a Time : $hours:$minutes"
                    ),
                    onTap: ()async{
                      TimeOfDay ? newTime = await showTimePicker(
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFFA88BEB),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFFA88BEB),
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Color(0xFFA88BEB), // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                        context: context,
                        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
                      );
                      if(newTime == null) return ;

                      final newDateTime = DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        newTime.hour,
                        newTime.minute,
                      );
                      setState(() => dateTime = newDateTime);
                    },
                  ),
                  // Text('$hours:$minutes'),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // ElevatedButton(
                  //     onPressed: ()async{
                  //       TimeOfDay ? newTime = await showTimePicker(
                  //           context: context,
                  //           initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
                  //       );
                  //       if(newTime == null) return ;
                  //
                  //       final newDateTime = DateTime(
                  //         dateTime.year,
                  //         dateTime.month,
                  //         dateTime.day,
                  //         newTime.hour,
                  //         newTime.minute,
                  //       );
                  //       setState(() => dateTime = newDateTime);
                  //     },
                  //     child: Text('Select Date')),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setReminder();
                      showSnackBar(context, Colors.greenAccent, "Reminder Saved Successfully");
                      nextScreenReplace(context, RemindersView(
                          groupId: widget.groupId,
                        admin: widget.admin,
                        name: widget.name,
                        userId: widget.userId,
                      ));
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFA88BEB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('SAVE', style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5,),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
  // Future setReminder() async{
  //
  //   await DatabaseService().savingReminder(_titleController.text, _descriptionController.text, dateTime);
  //
  //
  // }
  setReminder(){
    if(_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty){
      Map<String, dynamic> reminderMap = {
        "title": _titleController.text,
        "description": _descriptionController.text,
        "dateTime": dateTime
      };
      DatabaseService().savingReminder(widget.groupId, reminderMap);

    }
  }
}


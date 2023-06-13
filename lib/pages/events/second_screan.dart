import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:itum_communication_platform/pages/events/event_home.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp2(),
    );
  }
}
class MyApp2 extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyApp2> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }


  //const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Event'),
        backgroundColor: Color(0xFFA88BEB),
        leading: IconButton(
          icon: Icon(
            Icons.close_sharp,
          ),
          onPressed: () {
            Navigator.pop(context, EventHomePage());
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [

            tab1(),
            tab2(),
            calo(),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: _selectTime,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFA88BEB),),
                child: Text("Select the Time")
            ),
            SizedBox(height: 8),

          ],
        ),
      ),
    );
  }
}

Widget tab1() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        maxLength: 100,
        decoration: InputDecoration(
          hintText: 'Event name ',
          hintStyle: TextStyle(
            color: Color(0xFFA88BEB),
            fontSize: 20.0,
          ),
          icon: Icon(Icons.text_fields,color: Color(0xFFA88BEB)),
        ),
      ),
    ),
  );
}

Widget tab2() {
  return Container(
    child: const Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        maxLength: 100,
        decoration: InputDecoration(
          hintText: 'Location',
          hintStyle: TextStyle(
            color: Color(0xFFA88BEB),
            fontSize: 20.0,
          ),
          icon: Icon(Icons.location_on_outlined,color: Color(0xFFA88BEB),),
        ),
      ),
    ),
  );
}

class calo extends StatelessWidget {
  //const calo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ElevatedButton(

            onPressed: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2099, 12, 31), onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    print('confirm $date');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFA88BEB),),

            child: Text(
              'Select the Date',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),


        ),

      ],
    );
  }
}

/*
Widget start() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        maxLength: 100,
        decoration: InputDecoration(
          hintText: 'Start time',
          hintStyle: TextStyle(
            color: Colors.indigo,
            fontSize: 20.0,
          ),
          icon: Icon(Icons.location_on_outlined),
        ),
      ),
    ),
    child: Center(
        child: Text('Test'),
      )

  );
}

Column(
          children: [
                        Switch(
                            value: isDisabled,
                            onChanged: (check) {
                              setState(() {
                                isDisabled = check;
                              });
                            }),
                        RaisedButton(
                          onPressed: isDisabled
                              ? null
                              : () {
                                  print("Clicked");
                                },
                          child: Text("Click Me"),
                        ),
                 ],
        )

*/
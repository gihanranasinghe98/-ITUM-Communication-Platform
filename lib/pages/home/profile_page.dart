import 'package:flutter/material.dart';
import 'package:itum_communication_platform/pages/events/event_home.dart';
import 'package:itum_communication_platform/pages/groups/groups_home_page.dart';
import 'package:itum_communication_platform/pages/jobs/jobs_home_page.dart';
import 'package:itum_communication_platform/service/auth_service.dart';
import 'package:itum_communication_platform/widgets/widegets.dart';
import 'package:lottie/lottie.dart';

import '../auth/Login_Page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white,)),
        ),
        actions: [
          Icon(Icons.edit),
          SizedBox(width: 15,)
        ],
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
        //backgroundColor: const Color(0xff649EFF),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)
              )
          )
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Lottie.network('https://assets10.lottiefiles.com/packages/lf20_QpolL2.json',
              height: 200,
              fit: BoxFit.fill,),
            //Icon(Icons.account_circle, size: 150, color: Colors.grey[700],),
            const SizedBox(height: 35,),
            // Text(widget.userName, textAlign: TextAlign.center,
            //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            // const SizedBox(height: 30,),
            // const Divider(height: 2,),
            ListTile(
              onTap: (){
                nextScreen(context, const GroupHome());
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text('Groups', style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){},
              selectedColor: const Color(0xFFA88BEB),
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text('Profile', style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                nextScreen(context,  JobsHomePage());
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.work),
              title: const Text('Create Jobs', style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                nextScreen(context, EventHomePage());
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.event, ),
              title: const Text('Organize Events', style: TextStyle(color: Colors.black),),
            )  ,
            ListTile(
              onTap: ()async{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text('LogOut'),
                        content: Text('Are you sure you want to LogOut?'),
                        actions: [
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.cancel, color: Colors.red,)),
                          IconButton(
                              onPressed: ()async{
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context)=>const LoginPage()),
                                        (route)=>false );
                              },
                              icon: Icon(Icons.done, color: Colors.green,))
                        ],
                      );
                    });

              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text('LogOut', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),

      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.network('https://assets7.lottiefiles.com/packages/lf20_ia8jpabk.json',
              height: 150,
              fit: BoxFit.fill,),
            //Icon(Icons.account_circle, size: 200, color: Colors.grey[700],),
            const SizedBox(height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name",style: TextStyle(fontSize: 17),),
                Text(widget.userName,style: TextStyle(fontSize: 17),),
              ],
            ),
            const Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email",style: TextStyle(fontSize: 17),),
                Text(widget.email,style: TextStyle(fontSize: 17),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

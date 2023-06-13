import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itum_communication_platform/notifications/inbox_notifications.dart';
import 'package:itum_communication_platform/pages/groups/add_members.dart';
import 'package:itum_communication_platform/pages/polls/polls_home_page.dart';
import 'package:itum_communication_platform/pages/polls/polls_view.dart';
import 'package:itum_communication_platform/pages/reminders/reminders_home_page.dart';
import 'package:itum_communication_platform/pages/reminders/reminders_view_page.dart';
import 'package:itum_communication_platform/service/database_service.dart';
import 'package:itum_communication_platform/widgets/message_tile.dart';
import 'package:itum_communication_platform/widgets/widegets.dart';

import '../../helper/helper_function.dart';
import '../events/event_home.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage({Key? key,
    required this.groupName,
    required this.groupId,
    required this.userName,
  })
      : super(key: key);


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? adminChats;
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  TextEditingController adminMessageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String admin = "";
  String name = "";
  String groupId = "";
  String userId =DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).uid.toString();

  @override
  void initState() {
    getChatAdmin();
    gettingUserData();
    super.initState();
  }

  gettingUserData()async{
    await HelperFunctions.getUserNameFromSF().then((val){
      setState(() {
        name = val!;
      });
    });
  }

  getChatAdmin(){
    DatabaseService().getChats(widget.groupId).then((val){
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getAdminChats(widget.groupId).then((val){
      setState(() {
        adminChats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val){
      setState(() {
        admin = val;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Color(0xFFF1EDF4),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(widget.groupName, style: const TextStyle(color: Colors.white),),
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
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
            actions: [
              IconButton(
                  onPressed: (){
                    nextScreen(context, PollsViewPage());
                  },
                  icon: Icon(Icons.poll, color: Colors.white,)),
              IconButton(
                  onPressed: (){
                    nextScreen(context, RemindersView(
                      groupId: widget.groupId,
                      admin : admin,
                      name : name,
                      userId: userId,
                    ));
                  },
                  icon: Icon(Icons.notifications, color: Colors.white,)),
              Builder(
                builder: (context) => IconButton(
                    onPressed: (){
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(Icons.more_vert, color: Colors.white,)),
              ),
            ],
            bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                    insets: EdgeInsets.symmetric(horizontal: 16),
                    borderSide: BorderSide(color: Colors.blue, width: 3.0)
                ),
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Students',
                  ),
                  Tab(
                    text: 'Admin',
                  )
                ]),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)
                )
            ),
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: <Widget>[
                ListTile(
                  onTap: (){
                    nextScreen(context, GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                    ));
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.info, color: Color(0xFFA88BEB),),
                  title: const Text('Group Info', style: TextStyle(color: Colors.black),),
                ),
                "${userId}_$name"== admin ? ListTile(
                  onTap: (){
                    nextScreen(context, AddMembers(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                    ));
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.add, color: Color(0xFFA88BEB),),
                  title: const Text('Add or Remove Members', style: TextStyle(color: Colors.black),),
                ) : Container() ,

                ListTile(
                  onTap: (){
                    nextScreen(context, PollsHome(
                    ));
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.poll, color: Color(0xFFA88BEB),),
                  title: const Text('Create Polls', style: TextStyle(color: Colors.black),),
                ),
                "${userId}_$name"== admin ? ListTile(
                  onTap: (){
                    nextScreen(context, RemindersHome(
                      groupId: widget.groupId,
                      admin: admin,
                      userId: userId,
                      name: name,
                    ));
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.notifications, color: Color(0xFFA88BEB),),
                  title: const Text('Create Reminders', style: TextStyle(color: Colors.black),),
                ): Container(),
              ],
            ),
          ),
          body: Column(
            children: [

              Expanded(
                child: TabBarView(
                    children: [
                      Container(
                          child: Stack(
                            children: <Widget>[
                              chatMessages(),
                              Container(
                                alignment: Alignment.bottomCenter,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.grey[700],
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextFormField(
                                            controller: messageController,
                                            style: const TextStyle(color: Colors.white),
                                            decoration: const InputDecoration(
                                              hintText: "Send a message...",
                                              hintStyle: TextStyle(color: Colors.white),
                                              border: InputBorder.none,
                                            ),
                                          )),
                                      const SizedBox(width: 12,),
                                      GestureDetector(
                                        onTap: (){
                                          sendMessage();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFA88BEB),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.send, color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          child: "${userId}_$name"== admin ?
                          Container(
                              child: Stack(
                                children: <Widget>[
                                  adminChatMessages(),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    width: MediaQuery.of(context).size.width,
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Colors.grey[700],
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: TextFormField(
                                                controller: adminMessageController,
                                                style: const TextStyle(color: Colors.white),
                                                decoration: const InputDecoration(
                                                  hintText: "Send a message...",
                                                  hintStyle: TextStyle(color: Colors.white),
                                                  border: InputBorder.none,
                                                ),
                                              )),
                                          const SizedBox(width: 12,),
                                          GestureDetector(
                                            onTap: (){
                                              adminSendMessage();
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff649EFF),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: const Center(
                                                child: Icon(Icons.send, color: Colors.white,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                          )
                              : Stack(
                              children:<Widget>[
                                adminChatMessages(),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                    decoration: BoxDecoration(
                                      color: Color(0xffE5F9FF),
                                    ),

                                    width: MediaQuery.of(context).size.width,
                                    child: Text('Only admin can send messeges',
                                      textAlign: TextAlign.center,),
                                  ),
                                ),
                              ]
                          )
                      )
                    ]),
              )
            ],
          )

      ),
    );
  }
  chatMessages(){
    return StreamBuilder(
        stream: chats,
        builder: (context,AsyncSnapshot snapshot){
          return snapshot.hasData ?
          ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data.docs.length + 1,
            itemBuilder: (context, index){
              // if(snapshot.data.docs.length>0) {
              //   scrollDown();
              //
              // }
              if(index == snapshot.data.docs.length){

                return Container(height: 100,);
              }
              return MessageTile(
                  message: snapshot.data.docs[index]['message'],
                  sender: snapshot.data.docs[index]['sender'],
                  sentByMe: widget.userName == snapshot.data.docs[index]['sender']);
            },

          )
              : Container();

        });

  }

  adminChatMessages(){
    return StreamBuilder(
        stream: adminChats,
        builder: (context,AsyncSnapshot snapshot){
          return snapshot.hasData ?
          ListView.builder(

            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
                  message: snapshot.data.docs[index]['message'],
                  sender: snapshot.data.docs[index]['sender'],
                  sentByMe: widget.userName == snapshot.data.docs[index]['sender']);
            },
          )
              : Container();
        });
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      scrollDown();
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  scrollDown(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent , duration: Duration(microseconds: 300), curve: Curves.easeOut);
  }

  adminSendMessage(){
    if(adminMessageController.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        "message": adminMessageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      DatabaseService().adminSendMessage(widget.groupId, chatMessageMap);
      setState(() {
        adminMessageController.clear();
      });
    }
  }




}

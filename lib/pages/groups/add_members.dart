import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itum_communication_platform/pages/groups/chat_page.dart';
import 'package:itum_communication_platform/service/database_service.dart';

import '../../widgets/widegets.dart';

class AddMembers extends StatefulWidget {
  final String groupId;
  final String groupName;
  const AddMembers({Key? key,
    required this.groupName,
    required this.groupId
  }) : super(key: key);

  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String a = "@itum.mrt.ac.lk";
  bool isAdded = false;
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: const Color(0xffE5F9FF),
        iconTheme: const IconThemeData(color:Colors.white),
        title: Expanded(
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search members..."
              ),
            )),
        actions: [
          GestureDetector(
            onTap: (){
              initiateSearchMethod();
            },
            child: Container(
              width: 40,
              height: 40,
              // decoration: BoxDecoration(
              //   color: Colors.black.withOpacity(0.1),
              //   borderRadius: BorderRadius.circular(20),
              // ),
              child: const Icon(Icons.search),
            ),
          ),
          SizedBox(width: 20,)
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)
            )
        ),
      ),
      body: Column(
        children: [
          Container(),
           isLoading ? const Center(child: CircularProgressIndicator(),) : memberList(),
        ],
      ),
    );
  }



  initiateSearchMethod() async{
    if(searchController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByFullName(searchController.text).then((snapshot){
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });

    }
  }

   memberList(){
     return hasUserSearched
         ? ListView.builder(
       shrinkWrap: true,
       itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index){
           return groupTile(
             widget.groupName,
             widget.groupId,
             searchSnapshot!.docs[index]['fullName'],
             searchSnapshot!.docs[index]['uid'],
             searchSnapshot!.docs[index]['email'],
           );
        },
     ) :Container();
   }

  addedOrNot( String groupId, String fullName, String userid)async{
    await DatabaseService().isUserAdded( groupId,fullName, userid).then((value){
      setState(() {
        isAdded = value;

      });
    });
  }

  Widget groupTile(String groupName, String groupId,String fullName,  String userid, String email){
    addedOrNot(groupId, fullName, userid);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Color(0xffE5F9FF),
        child: Text(fullName.substring(0,1).toUpperCase(),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      ),
      title: Text(fullName, style: const TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text(email),
      trailing: InkWell(
        onTap: ()async{
          await DatabaseService()
              .toggleGroupAdd(groupName, groupId, fullName, userid );
          if(isAdded){
            setState(() {
              isAdded = !isAdded;
            });
            showSnackBar(context, Colors.greenAccent, "Successfuly joined the group");
            Future.delayed(const Duration(seconds: 2),(){
              nextScreen(context, ChatPage(
                groupName: groupName,
                groupId: groupId,
                userName: fullName,
              ));
            });
          }
          else{
            setState(() {
              isAdded = !isAdded;
              showSnackBar(context, Colors.red, "Left the group $groupName");
            });
          }
        },
        child: isAdded
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white,width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text("Remove",
            style: TextStyle(color: Colors.white),
          ),
        )
            : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white,width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text("Add now",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

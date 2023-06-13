import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");
  final CollectionReference reminderCollection =
  FirebaseFirestore.instance.collection("reminders");

  // saving the userdata
  Future savingUserData(String fullName, String email) async{
    return await userCollection.doc(uid).set({
      "fullName" : fullName,
      "email" : email,
      "reg" : email.replaceAll("@itum.mrt.ac.lk",""),
      "groups" : [],
      "profilePic" : "",
      "uid" : uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async{
    QuerySnapshot snapshot =
    await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }

  // getReminders() async{
  //   return reminderCollection.doc(uid).snapshots();
  // }



  // creating a group
  Future createGroup(String userName, String id, String groupName) async{
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName" : groupName,
      "groupIcon" : "",
      "admin" : "${id}_$userName",
      "members" : [],
      "groupId" : "",
      "recentMessage" : "",
      "recentMessageSender" : "",
    });

    // update the members
    await groupDocumentReference.update({
      "members" : FieldValue.arrayUnion(["${id}_$userName"]),
      "groupId" : groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups" : FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // getting the chats
  getChats(String groupId) async{
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  getAdminChats(String groupId) async{
    return groupCollection
        .doc(groupId)
        .collection("adminMessages")
        .orderBy("time")
        .snapshots();
  }

  getReminders(String groupId) async{
    return groupCollection
        .doc(groupId)
        .collection("reminders")
        .orderBy("dateTime")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }



  // get group members
  getGroupMembers(groupId) async{
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName){
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  //search by ITUMemail
  searchByEmail(String reg){
    return userCollection.where("reg", isEqualTo: reg).get();
  }

  //search by ITUMemail
  searchByFullName(String fullName){
    return userCollection.where("fullName", isEqualTo: fullName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(String groupName, String groupId, String userName) async{
    DocumentReference userDocumentReference =userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupName")){
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> isUserAdded( String groupId, String userName,String userId) async{
    DocumentReference groupDocumentReference =groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await groupDocumentReference.get();

    List<dynamic> members = await documentSnapshot['members'];
    if(members.contains("${userId}_$userName")){
      return true;
    }
    else{
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(String groupId, String userName, String groupName)async{
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = userCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if(groups.contains("${groupId}_$groupName")){
      await userDocumentReference.update({
        "groups" : FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members" : FieldValue.arrayRemove(["${uid}_$userName"])
      });
    }
    else{
      await userDocumentReference.update({
        "groups" : FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members" : FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  Future toggleGroupAdd(String groupName, String groupId, String userName, String userid)async{
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(userid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if(groups.contains("${groupId}_$groupName")){
      await userDocumentReference.update({
        "groups" : FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members" : FieldValue.arrayRemove(["${userid}_$userName"])
      });
    }
    else{
      await userDocumentReference.update({
        "groups" : FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members" : FieldValue.arrayUnion(["${userid}_$userName"])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async{
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['messages'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  adminSendMessage(String groupId, Map<String, dynamic> chatMessageData) async{
    groupCollection.doc(groupId).collection("adminMessages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['messages'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  savingReminder(String groupId, Map<String, dynamic> reminderData) async{
    groupCollection.doc(groupId).collection("reminders").add(reminderData);
    groupCollection.doc(groupId).update({
      "title": reminderData['title'],
      "description": reminderData['description'],
      "dateTime": reminderData['dateTime'],
    });
  }

// Future savingReminder(String title, String description, DateTime date) async{
//   return await reminderCollection.doc(uid).set({
//     "title" : title,
//     "description" : description,
//     "date" : date,
//   });
// }
}
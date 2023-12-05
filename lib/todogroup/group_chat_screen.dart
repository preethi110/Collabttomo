
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomo/Authenticate/Methods.dart';
import 'package:tomo/todogroup/add_members.dart';
import 'package:tomo/todogroup/group_todo_room.dart';


class GrouptodoHomeScreen extends StatefulWidget {
  const GrouptodoHomeScreen({Key? key}) : super(key: key);

  @override
  _GrouptodoHomeScreenState createState() => _GrouptodoHomeScreenState();
}

class _GrouptodoHomeScreenState extends State<GrouptodoHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
     backgroundColor: Colors.yellow.shade50,
      appBar: AppBar(
          actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        ],
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
           centerTitle: true,
        title: Text("Groups"),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              color: Colors.black,
                           child: CircularProgressIndicator(
        backgroundColor: Colors.black,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade100), // Color of the progress indicator
      ),
            )
          : Container(
             padding: EdgeInsets.symmetric(vertical: 10.0),
            child: ListView.builder(
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>  GrouptodoRoom (
                          groupName: groupList[index]['name'],
                          groupChatId: groupList[index]['id'],
                        ),
                      ),
                    ),
                    leading: Icon(Icons.group),
                    title: Text(groupList[index]['name']),
                  );
                },
              ),
          ),
      floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.black,
        child: Icon(Icons.create),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddMembersInGroup(),
          ),
        ),
        tooltip: "Create Group",
      ),
    );
  }
}
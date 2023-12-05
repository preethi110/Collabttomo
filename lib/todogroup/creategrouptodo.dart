import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tomo/todogroup/group_chat_screen.dart';
import 'package:uuid/uuid.dart';



class CretodoG extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

  const CretodoG({required this.membersList, Key? key}) : super(key: key);

  @override
  State<CretodoG> createState() => _CretodoGState();
}

class _CretodoGState extends State<CretodoG> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void CretodoG() async {
    setState(() {
      isLoading = true;
    });

    String groupId = Uuid().v1();

    await _firestore.collection('groups').doc(groupId).set({
      "members": widget.membersList,
      "id": groupId,
    });

    for (int i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]['uid'];

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "name": _groupName.text,
        "id": groupId,
      });
    }

  
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => GrouptodoHomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
         backgroundColor: Colors.black,
        title: Text("Group Name"),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                 color: Colors.black,
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 10,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _groupName,
                      decoration: InputDecoration(
                        hintText: "Enter Group Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                   style: ElevatedButton.styleFrom(
    primary: Colors.black, // Set the color to black
  ),
                  onPressed: CretodoG,
                  child: Text("Create Group"),
                ),
              ],
            ),
    );
  }
}


//
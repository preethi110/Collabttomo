import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomo/group_chats/group_info.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:tomo/todogroup/tododialog.dart';

import '../utils/colors.dart';


class GrouptodoRoom extends StatefulWidget {
  final String groupChatId, groupName;

  GrouptodoRoom({required this.groupName, required this.groupChatId, Key? key})
      : super(key: key);

    @override
  State<GrouptodoRoom > createState() => _GrouptodoRoomState(groupChatId, groupName);  
}  
 
class _GrouptodoRoomState extends State<GrouptodoRoom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String groupChatId, groupName;

  _GrouptodoRoomState(this.groupChatId, this.groupName);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor:Color(0xFFFFE4C7),
      appBar: AppBar(
         backgroundColor:Color.fromARGB(255, 16, 0, 0),
        title: Text(groupName),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupInfo(
                        groupName: groupName,
                        groupId: groupChatId,
                      ),
                    ),
                  ),
              icon: Icon(Icons.more_vert)),
        ],
      ),
        extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:  Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return  AddTaskAlertDialog(groupChatId: groupChatId);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
        SizedBox(height: 16.0),
            ],
  ),
      
      body: Container(
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
                   stream: _firestore
                    .collection('groups')
                    .doc(groupChatId)
                    .collection('tasks')
                    .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return  Text('No tasks to display');
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                Color taskColor = AppColors.blueShadeColor;
                var taskTag = data['taskTag'];
                if (taskTag == 'Work') {
                  taskColor = AppColors.salmonColor;
                } else if (taskTag == 'School') {
                  taskColor = AppColors.greenShadeColor;
                }
                return Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xFFFED4D6),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 5.0,
                        offset: Offset(0, 5), // shadow direction: bottom right
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: taskColor,
                      ),
                    ),
                    title: Text(data['taskName']),
                    subtitle: Text(data['taskDesc']),
                    isThreeLine: true,
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () {
                              String taskId = (data['id']);
                              String taskName = (data['taskName']);
                              String taskDesc = (data['taskDesc']);
                              String taskTag = (data['taskTag']);
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                  context: context,
                                  builder: (context) => UpdateTaskAlertDialog(groupChatId: groupChatId,taskId: taskId, taskName: taskName, taskDesc: taskDesc, taskTag: taskTag,),
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: (){
                              String taskId = (data['id']);
                              String taskName = (data['taskName']);
                              Future.delayed(
                                const Duration(seconds: 0),
                                    () => showDialog(
                                  context: context,
                                  builder: (context) => DeleteTaskDialog(groupChatId: groupChatId,taskId: taskId, taskName:taskName),
                                ),
                              );
                            },
                          ),
                        ];
                      },
                    ),
                    dense: true,
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    ),

      
    );
  }

}

class AddTaskAlertDialog extends StatefulWidget {
  final String groupChatId;

  const AddTaskAlertDialog({required this.groupChatId, Key? key}) : super(key: key);

  @override
  State<AddTaskAlertDialog> createState() => _AddTaskAlertDialogState(groupChatId);
}

class _AddTaskAlertDialogState extends State<AddTaskAlertDialog> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final List<String> taskTags = ['Work', 'School', 'Other'];
  late String selectedValue = '';
  
  final String groupChatId;

  _AddTaskAlertDialogState(this.groupChatId);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'New Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
      ),
      content: SizedBox(
        height: height * 0.35,
        width: width,
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: taskNameController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: 'Task',
                    hintStyle: const TextStyle(fontSize: 14),
                    icon: const Icon(CupertinoIcons.square_list, color: Color.fromARGB(255, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: taskDescController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: 'Description',
                    hintStyle: const TextStyle(fontSize: 14),
                    icon: const Icon(CupertinoIcons.bubble_left_bubble_right, color: Color.fromARGB(255, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    const Icon(CupertinoIcons.tag, color: Color.fromARGB(255, 0, 0, 0)),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        hint: const Text(
                          'Add a task tag',
                          style: TextStyle(fontSize: 14),
                        ),
                               buttonStyleData: ButtonStyleData(height: 60,
                        padding: const EdgeInsets.only(left: 20, right: 10),
                       decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        ),
                
          
                        items: taskTags
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) => setState(() {
                            if (value != null) selectedValue = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 0, 0, 0),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final taskName = taskNameController.text;
            final taskDesc = taskDescController.text;
            final taskTag = selectedValue;
            _addTasks(taskName: taskName, taskDesc: taskDesc, taskTag: taskTag);
            Navigator.of(context, rootNavigator: true).pop();
          },
             style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 0, 0, 0),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future _addTasks({required String taskName, required String taskDesc, required String taskTag}) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('groups')
    .doc(groupChatId).collection('tasks').add(
      {
        'taskName': taskName,
        'taskDesc': taskDesc,
        'taskTag': taskTag,
      },
    );
    String taskId = docRef.id;
    await FirebaseFirestore.instance.collection('groups')
    .doc(groupChatId).collection('tasks').doc(taskId).update(
      {'id': taskId},
    );
    _clearAll();
  }

  void _clearAll() {
    taskNameController.text = '';
    taskDescController.text = '';
  }
}

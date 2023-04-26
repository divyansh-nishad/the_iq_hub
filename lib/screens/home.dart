import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_iq_hub/screens/auth_page.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ToDoDataBase db = ToDoDataBase();
  // create a firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _todoCollectionRef =
      FirebaseFirestore.instance.collection('todos');

// text controller
  final _controller = TextEditingController();

  void saveNewTask() async {
    await _todoCollectionRef.add({
      'taskName': _controller.text,
      'taskCompleted': false,
    });
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () {
            saveNewTask();
            _controller.clear();
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(String todoId) {
    db.deleteTodo(todoId);
  }

  // update task status
  void updateTaskStatus(String todoId, bool taskCompleted) async {
    await _todoCollectionRef
        .doc(todoId)
        .update({'taskCompleted': taskCompleted});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Your Tasks', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        shadowColor: Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              signUserOut();
            },
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _todoCollectionRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(
                    Icons.add_circle,
                    color: Colors.grey[700],
                    size: 75,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('No tasks added yet')
                ]));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var todo = snapshot.data!.docs[index];
              return ToDoTile(
                taskName: todo['taskName'],
                taskCompleted: todo['taskCompleted'],
                onChanged: (value) => updateTaskStatus(todo.id, value!),
                onDelete: () => deleteTask(todo.id),
              );
            },
          );
        },
      ),
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthPage(),
      ),
    );
  }
}

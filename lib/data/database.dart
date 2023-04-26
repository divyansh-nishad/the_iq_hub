import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoDataBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _todoCollectionRef;

  ToDoDataBase() {
    _todoCollectionRef = _firestore.collection('todos');
  }

  Future<void> addTodo(String taskName) async {
    await _todoCollectionRef.add({
      'taskName': taskName,
      'taskCompleted': false,
    });
  }

  Future<void> updateTodoStatus(String todoId, bool taskCompleted) async {
    await _todoCollectionRef.doc(todoId).update({'taskCompleted': taskCompleted});
  }

  Future<void> deleteTodo(String todoId) async {
    await _todoCollectionRef.doc(todoId).delete();
  }

  Stream<List<DocumentSnapshot>> getTodosStream() {
    return _todoCollectionRef.snapshots().map((snapshot) => snapshot.docs);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky/models/task.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's UID
  String get userId => _auth.currentUser!.uid;

  // Reference to the tasks collection for this user
  CollectionReference get _taskCollection =>
      _db.collection('users').doc(userId).collection('tasks');

  // CREATE Task
  Future<void> addTask(Task task) async {
    await _taskCollection.doc(task.id).set(task.toMap());
  }

  // READ Tasks as a Stream
  Stream<List<Task>> getTasks() {
    return _taskCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // UPDATE Task
  Future<void> updateTask(Task task) async {
    await _taskCollection.doc(task.id).update(task.toMap());
  }

  // DELETE Task
  Future<void> deleteTask(String taskId) async {
    await _taskCollection.doc(taskId).delete();
  }
}

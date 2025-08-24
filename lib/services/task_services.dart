import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky/models/task.dart';
import 'package:tasky/widgets/filter_sheet.dart'; // Import the new enum

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  CollectionReference get _taskCollection =>
      _db.collection('users').doc(userId).collection('tasks');

  // CREATE Task
  Future<void> addTask(Task task) async {
    await _taskCollection.doc(task.id).set(task.toMap());
  }

  // READ Tasks as a Stream, now with optional filters and sorting
  Stream<List<Task>> getTasks({TaskFilter filter = TaskFilter.all}) {
    Query query = _taskCollection;

    // Apply filters based on the selected option
    switch (filter) {
      case TaskFilter.completed:
        query = query.where('isCompleted', isEqualTo: true);
        break;
      case TaskFilter.incomplete:
        query = query.where('isCompleted', isEqualTo: false);
        break;
      case TaskFilter.highPriority:
        query = query.where('priority', isEqualTo: 'high');
        break;
      case TaskFilter.mediumPriority:
        query = query.where('priority', isEqualTo: 'medium');
        break;
      case TaskFilter.lowPriority:
        query = query.where('priority', isEqualTo: 'low');
        break;
      case TaskFilter.all:
      default:
        // No filter applied, returns all tasks
        break;
    }

    // Always sort by time in descending order to show the newest tasks first
    query = query.orderBy('time', descending: true);

    return query.snapshots().map((snapshot) => snapshot.docs
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

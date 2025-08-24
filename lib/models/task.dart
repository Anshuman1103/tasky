class Task {
  Task({
    required this.id,
    required this.title,
    required this.detail,
    required this.priority,
    required this.isCompleted,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  final String id;
  final String title;
  final String? detail;
  final Priority priority;
  final bool isCompleted;
  final DateTime time;

  // Convert Task object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'detail': detail,
      'priority': priority.name, // store as string
      'isCompleted': isCompleted,
      'time': time.toIso8601String(), // store as string
    };
  }

  // Convert Firestore document to Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      detail: map['detail'],
      priority: Priority.values.firstWhere((p) => p.name == map['priority']),
      isCompleted: map['isCompleted'],
      time: DateTime.parse(map['time']),
    );
  }
}

enum Priority {
  high,
  medium,
  low,
}

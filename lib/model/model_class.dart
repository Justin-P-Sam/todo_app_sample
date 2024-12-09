class TodoModel {
  int? id;
  String todoTitle;
  bool completed;

  TodoModel({this.id, required this.todoTitle, required this.completed});

  // Convert TodoModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': todoTitle,
      'completed': completed ? 1 : 0, // Store 1 for true and 0 for false
    };
  }

  // Convert Map to TodoModel
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      todoTitle: map['title'],
      completed: map['completed'] == 1,
    );
  }

  // Toggle the completion status
  void toggleCompleted() {
    completed = !completed;
  }
}

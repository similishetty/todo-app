class TodoEntity {
  int? userId;
  int? id;
  String? title;
  bool? completed;

  TodoEntity({
    this.userId,
    this.id,
    this.title,
    this.completed,
  });
  factory TodoEntity.fromJson(Map<String, dynamic> json) => TodoEntity(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
  };
}

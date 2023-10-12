import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class ToDo {
  String id;
  String todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  // Deserialize JSON to Album object
  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);

  // Serialize Album object to JSON
  Map<String, dynamic> toJson() => _$ToDoToJson(this);
}

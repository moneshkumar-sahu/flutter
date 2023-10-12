import 'dart:convert';
import 'package:flutter_todo_application/model/todo.dart';
import 'package:http/http.dart' as http;

/// Fetches a list of todo from the server.
Future<List<ToDo>> fetchToDos() async {
  final response = await http.get(Uri.parse('http://192.168.2.221:8000/todo'));
  if (response.statusCode == 200) {
    // If the server returned a 200 OK response, parse the JSON.
    final List<dynamic> todoList = jsonDecode(response.body);
    return todoList.map((todoData) => ToDo.fromJson(todoData)).toList();
  } else {
    throw Exception('Failed to fetch albums.');
  }
}

/// Creates a new todo on the server with the provided [toDo].
Future<ToDo> createToDo(ToDo toDo) async {
  final response = await http.post(
    Uri.parse('http://192.168.2.221:8000/todo'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': toDo.id,
      'todoText': toDo.todoText,
      'isDone': toDo.isDone,
    }),
  );

  if (response.statusCode == 201) {
    // If the server returned a 201 CREATED response, parse the JSON.
    return ToDo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

/// Deletes an todo from the server based on its [id].
Future<ToDo> deleteToDo(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('http://192.168.2.221:8000/todo/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return ToDo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to delete album.');
  }
}

/// Updates an todo's [isDone] on the server based on its [id].
Future<ToDo> updateToDo(String id, bool isDone) async {
  final response = await http.patch(
    Uri.parse('http://192.168.2.221:8000/todo/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{'isDone': isDone}),
  );

  if (response.statusCode == 200) {
    // If the server returned a 200 OK response, parse the JSON.
    return ToDo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update album.');
  }
}

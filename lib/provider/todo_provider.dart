import 'package:flutter/material.dart';
import 'package:flutter_todo_application/model/todo.dart';
import 'package:flutter_todo_application/services/api_service.dart';

class TodoProvider extends ChangeNotifier {
  List<ToDo> _todoList = [];

  List<ToDo> get todoList => _todoList;

  bool isButtonDisabled = true;
  String error = '';

  // void addToDoItem(String toDo) {
  //   _todoList.add(ToDo(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     todoText: toDo,
  //   ));
  //   notifyListeners();
  // }

  // void toggleToDoStatus(String id) {
  //   final todo = todoList.firstWhere((item) => item.id == id);
  //   todo.isDone = !todo.isDone;
  //   notifyListeners();
  // }

  // void deleteToDoItem(String id) {
  //   _todoList.removeWhere((item) => item.id == id);
  //   notifyListeners();
  // }

  void notify() {
    notifyListeners();
  }

  Future<void> fetchToDo() async {
    try {
      _todoList = await fetchToDos();
    } catch (e) {
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> addToDoItem(String toDo) async {
    ToDo newTodo = ToDo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      todoText: toDo,
    );
    _todoList.add(await createToDo(newTodo));
    notifyListeners();
  }

  Future<void> deleteToDoItem(String id) async {
    try {
      _todoList.removeWhere((item) => item.id == id);
      notifyListeners();
      await deleteToDo(id);
    } catch (e) {
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleToDoStatus(String id) async {
    final todo = todoList.firstWhere((item) => item.id == id);
    todo.isDone = !todo.isDone;
    notifyListeners();
    try {
      await updateToDo(id, todo.isDone);
    } catch (e) {
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }
}

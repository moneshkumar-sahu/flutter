import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_application/provider/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';

@RoutePage()
class ToDoHome extends StatefulWidget {
  const ToDoHome({Key? key}) : super(key: key);

  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<TodoProvider>(context, listen: false).fetchToDo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _todoController = TextEditingController();
    var screenWidth = MediaQuery.of(context).size.width;

    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text('My ToDos : ${todoProvider.todoList.length}'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();
                context.router.pop();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: todoProvider.todoList.isEmpty
                    ? Center(
                        child: Image.asset(
                          'assets/images/empty.png',
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                        ),
                      )
                    : ListView(
                        children: [
                          for (ToDo todo in todoProvider.todoList.reversed)
                            ToDoItem(
                              todo: todo,
                              onToDoChanged: () =>
                                  todoProvider.toggleToDoStatus(todo.id),
                              onDeleteItem: () =>
                                  todoProvider.deleteToDoItem(todo.id),
                            ),
                        ],
                      ),
              ),
            ),
            Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none),
                    onChanged: (text) {
                      // Enable the button if the TextField is not empty, disable it otherwise.
                      todoProvider.isButtonDisabled = text.isEmpty;
                      todoProvider.notify();
                    },
                    onSubmitted: (text) {
                      // Call the onPressed function when Enter is pressed
                      if (!todoProvider.isButtonDisabled) {
                        todoProvider.addToDoItem(text);
                        todoProvider.isButtonDisabled = true;
                        _todoController.clear();
                      }
                    },
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: todoProvider.isButtonDisabled
                        ? null // Disable the button if isButtonDisabled is true
                        : () {
                            todoProvider.addToDoItem(_todoController.text);
                            todoProvider.isButtonDisabled = true;
                            _todoController.clear();
                            FocusScope.of(context).unfocus();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}

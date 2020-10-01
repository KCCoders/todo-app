import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/tododetail.dart';

class TodoList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TodoListState();

}

class TodoListState extends State {
  
  var helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }

    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo('',3,''));
        },
        tooltip: 'Add new Todo',
        child: Icon(Icons.add),
      ),
    );



  }

  ListView todoListItems() {


    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        var todo = this.todos[position];
        return Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.date),
            leading: CircleAvatar(
              backgroundColor: getColor(todo.priority),
              child: Text(todo.priority.toString()),
            ),
            onTap: () {
              debugPrint('Tapped on: ' + todo.id.toString());
              navigateToDetail(todo);
            },
          ),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((value) {
      final todosFuture = helper.getTodos();
      todosFuture.then((value) {
        List<Todo> todoList = List<Todo>();
        count = value.length;
        for (int i=0; i<count; i++) {
          todoList.add(Todo.fromObject(value[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint('Items: ' + count.toString());
      });

    });
  }

  Color getColor (int priority) {
    switch(priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      case 3:
      default:
        return Colors.green;
        break;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetail(todo),
      )
    );
    if (result == true) {
      getData();
    }
  }
}
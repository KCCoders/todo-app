import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

var db = DbHelper();
final List<String> menuChoices = const <String> ['Save', 'Delete', 'Back'];
const menuSave = 'Save';
const menuDelete = 'Delete';
const menuBack = 'Back';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);
  var _priority = 'Low';
  final _priorities = ['High', 'Medium', 'Low'];
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    var textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) {
              return menuChoices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top:35, left: 10, right:10),
        child: ListView(children: <Widget>[Column(
          children: <Widget> [
            TextField(
              controller: titleController,
              style: textStyle,
              onChanged: (value) => this.updateTitle(),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:15, bottom:15),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) => this.updateDescription(),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  )
                ),
              ),
            ),

              Container(
                padding: EdgeInsets.symmetric(horizontal:5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child:
                  Row(
                    children: <Widget>[
                      Text(
                          ' Priority',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      Container(width:20),
                      Expanded(
                        child: 
                          Container(
                            padding: EdgeInsets.symmetric(horizontal:20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child:
                            DropdownButton<String>(
                              items: _priorities.map((String value) {
                                return DropdownMenuItem<String> (
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(), 
                              underline: SizedBox(),
                              style: textStyle,
                              value: retrievePriority(todo.priority),
                              onChanged: (value) => updatePriority(value),
                            ),
                          ),
                      ),
                    ],
                  ),
              ),
          ],
        ),
        ],), 
      ),
    );
  }

  void select(String value) async {
    
    int result;
    switch (value) {
      case menuSave:
        save();
        break;
      case menuDelete:

        // if creating a new todo and you click delete, do nothing
        if (todo.id == null)
          return;

        // go back to previous screen
        Navigator.pop(context, true);

        // delete record and await the result
        result = await db.deleteTodo(todo.id);

        // when the result returns it will be greater than 0 
        // so show a message that the record is deleted
        if (result != 0) {
          var alertDialog = AlertDialog(
            title: Text('Delete Todo'),
            content: Text('The Todo has been deleted.'),
          );
          showDialog(
            context: context,
            builder: (_) => alertDialog,
          );
        }
        break;
      case menuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    todo.date = DateFormat.yMd().format(DateTime.now());

    if (todo.id != null) {
      db.updateTodo(todo);
    } else {
      db.insertTodo(todo);
    }

    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value-1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }
}
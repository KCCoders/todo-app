class Todo {

  // private properties
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  // constructors
  Todo (this._title, this._priority, this._date, [this._description]);
  Todo.withId(this._id, this._title, this._priority, this._date, [this._description]);

  // getters
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  // setters
  set title (String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description (String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set date (String newDate) {
    _date = newDate;
  }

  set priority (int newPriority) {
    if (newPriority >0 && newPriority<=3) {
      _priority = newPriority;
    }
  }

  // map
  Map <String, dynamic> toMap() {

    var map = Map<String, dynamic>();

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    if (_id != null) {
      map['id'] = _id;
    }

    return map;
  }

  Todo.fromObject(dynamic o) {
    this._id = o['id'];
    this._title = o['title'];
    this._description = o['description'];
    this._priority = o['priority'];
    this._date = o['date'];
  }
}
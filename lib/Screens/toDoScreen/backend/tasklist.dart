import 'package:mytodoapp/Screens/toDoScreen/backend/task.dart';

class TaskList {
  List<Task> _taskList;

  TaskList() {
    _taskList = new List();
  }

  TaskList.withTask(List<Task> list) {
    setTasksList(list);
  }

  List<Task> getTasksList() {
    return this._taskList;
  }

  void setTasksList(List<Task> list) {
    this._taskList = list;
  }

  void addTaskToTheList(Task newTask) {
    getTasksList().add(newTask);
  }

  void removeTaskFromList(String title, String desc) {
    getTasksList().forEach((element) {
      if (element.getTitle() == title && element.getDesc() == desc)
        getTasksList().remove(element);
    });
  }

  void printTaskList() {
    print(getTasksList());
  }
}

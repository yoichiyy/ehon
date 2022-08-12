// import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../task_list/todo.dart';

class EditTaskModel extends ChangeNotifier {
  final TodoForView todo;
  final taskNameController = TextEditingController();

  String? taskName;
  Timestamp createdAtForDisplay = Timestamp.fromDate(DateTime.now());
  // String? timestampString;

  EditTaskModel(this.todo) {
    taskNameController.text = todo.taskName;
  }

//こっちが、edit画面の更新表示用
  void updateForFirebase(DateTime dateSelected) {
    createdAtForDisplay = Timestamp.fromDate(dateSelected);
    notifyListeners();
  }

//stringをもらって、そのままtimestampというStringが更新される
  // void updateDueDateText(String stringDateSelected) {
  //   timestampString = stringDateSelected;
  //   notifyListeners();
  // }

  void setTaskName(String taskName) {
    this.taskName = taskName;
    notifyListeners();
  }

  bool isUpdated() {
    return taskName != null || createdAtForDisplay != null;
  }

  Future update() async {
    taskName = taskNameController.text;
    await FirebaseFirestore.instance
        .collection('todoList')
        .doc(todo.id)
        .update({
      'title': taskName,
      'createdAt': createdAtForDisplay,
    });
  }
}

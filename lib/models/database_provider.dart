import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/models/constants.dart';
import 'package:counter/models/counter_model.dart';
import 'package:counter/models/task_model.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

Future<int> getCounterForMonth(int month, int year) async {
  var box = await Hive.openBox<CounterModel>(hiveCounterBoxName);
  final values = box.values.toList();

  var count = 0;

  for (var counter in values) {
    final date = getDateFromId(counter.id);

    if (date.month == month && date.year == year) {
      count += counter.count;
    }
  }

  return count;
}

Future<CounterModel> getCounterForDay(DateTime date) async {
//

//hiveのcode
  var box = await Hive.openBox<CounterModel>(hiveCounterBoxName);
  final id = getIdFromDate(date);
  CounterModel? currentModel = box.get(id);
  return currentModel ?? CounterModel(count: 0, id: getIdFromDate(date));
}

Future<List<CounterModel>> getAllCounters() async {
  var box = await Hive.openBox<CounterModel>(hiveCounterBoxName);
  return box.values.toList();
  //final counterModel = CounterModel(id: "16-3-2022", count: 12);
  //return List.filled(200, counterModel);
}

Future<int> addCounter(DateTime date) async {
  //firebase

  //hive original code
  var box = await Hive.openBox<CounterModel>(hiveCounterBoxName);
  final CounterModel currentCounter = await getCounterForDay(date);
  final updatedCounter = (currentCounter.count) + 1;

  final counterModel = CounterModel(
    count: updatedCounter,
    id: currentCounter.id,
  );
  box.put(counterModel.key ?? counterModel.id, counterModel);
  return updatedCounter;
}

String getIdFromDate(DateTime date) {
  return "${date.day}-${date.month}-${date.year}";
}

DateTime getDateFromId(String id) {
  final getListOfNumbers = id.split("-").reversed.toList();
  return DateTime(int.parse(getListOfNumbers[0]),
      int.parse(getListOfNumbers[1]), int.parse(getListOfNumbers[2]));
}

// //hiveを用いた、addTask関数
// Future<TaskModel> addTask(DateTime date, String task) async {

//   var box = await Hive.openBox<TaskModel>(hiveTaskBoxName);
//   final taskModel = TaskModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: task,
//       date: date);
//   box.add(taskModel);
//   return taskModel;
// }

//↓質問用↓120-134　アンコメント
//・引数として持ってくるという条件だから、if使うのやめろということか？（上の青コメント）
//・isEmptyが、なぜgetter? （下の赤エラー）
//https://flutternyumon.com/dart-getter-setter/　→　getterここでの説明から、isEmptyがgetterだと言われると混乱。。

//削除したが、changenotifierの扱いはどうするか？
// class AddBookModel extends ChangeNotifier {
//   String? taskName;
//   String? dueDate;

// Future<void> addBook(DateTime dueDate, String taskName) async {
//   if (taskName == null || taskName == "") {
//     throw 'タイトルが入力されていません';
//   }

//   if (dueDate == null || dueDate!.isEmpty) {
//     throw '著者が入力されていません';
//   }

//   // firestoreに追加
//   await FirebaseFirestore.instance.collection('books').add({
//     'title': taskName,
//     'author': dueDate,
//   });
// }
// }

//作り直し。ifを外す
Future<void> addBook(DateTime dueDate, String taskName) async {
  if (taskName == "") {
    throw 'タイトルが入力されていません';
  }

  // firestoreに追加
  await FirebaseFirestore.instance.collection('books').add({
    'title': taskName,
    'author': dueDate,
  });
}

Future<List<TaskModel>> getAllTasks() async {
  var box = await Hive.openBox<TaskModel>(hiveTaskBoxName);
  return box.values.toList();
}

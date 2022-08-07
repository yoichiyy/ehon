import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/models/constants.dart';
import 'package:counter/models/counter_model.dart';
import 'package:counter/models/task_model.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

// 月の冊数カウント
Future<int> getCounterForMonth(int year, int month) async {
  final _store = FirebaseFirestore.instance;
  //FQ：これらの違いは？getとsnapshot。getは非同期futureで、
  //snapshotsはstream。リアルタイムデータ取得ということでOK？
  //どういうときにfutureを使い、どういうときにsnapshots?
  final ehonData = await _store.collection('ehoncount').get();
  final ehonCountStream = _store.collection('ehoncount').snapshots();
  ehonCountStream.listen((qs) {
    //変更があったら、listen以下がはしる。
    // print("おはよう");
  });

  //すべての絵本データのカウント：FQ：ehonDataの正体？ getで得たものはなにか？→snapshotを得たとある。snapshotとは？
  var countAll = ehonData.docs.length;
  //今月分だけを取得しようとしている。
  var monthData = await _store
      .collection('ehoncount')
      .where('ehon_year', isEqualTo: year.toString())
      .where('ehon_month', isEqualTo: month.toString())
      .get();

  var countMonth = monthData.docs.length;
  return countMonth;
//Kboyさんとのセッション。stampをStringとして表示させること＋QUERYの書き方
  //https://stackoverflow.com/questions/54014679/return-type-of-timestamp-from-firestore-and-comparing-to-datetime-now-in-flutt
  //firebase firestore timestamp greater than flutter
  //https://flutter.ctrnost.com/basic/interactive/form/datapicker/
}

// 日の冊数カウント
Future<int> getCounterForDay(int year, int month, int day) async {
  final _store = FirebaseFirestore.instance;
  var dayData = await _store
      .collection('ehoncount')
      .where('ehon_year', isEqualTo: year.toString())
      .where('ehon_month', isEqualTo: month.toString())
      .where('ehon_date', isEqualTo: day.toString())
      .get();
  var countDay = dayData.docs.length;
  return countDay;
}

//　全冊数のカウント
Future<int> getCounterForAll() async {
  final _store = FirebaseFirestore.instance;
  var allData = await _store.collection('ehoncount').get();
  var countAll = allData.docs.length;
  return countAll;
}

//hiveのコード
// Future<int> getCounterForMonth(int month, int year) async {
//   var box = await Hive.openBox<CounterModel>(hiveCounterBoxName);
//   final values = box.values.toList();
//   var count = 0;
//   for (var counter in values) {
//     final date = getDateFromId(counter.id);
//     if (date.month == month && date.year == year) {
//       count += counter.count;
//     }
//   }
//   return count;
// }

// Future<CounterModel> getCounterForDay(DateTime date) async {
// //hiveのcode
//   var box = await Hive.openBox<CounterModel>(hiveCounterBoxName);
//   final id = getIdFromDate(date);
//   CounterModel? currentModel = box.get(id);
//   return currentModel ?? CounterModel(count: 0, id: getIdFromDate(date));
// }

// Future<List<CounterModel>> getAllCounters() async {
//   var box = await Hive.openBox<CounterModel>(hiveCounterBoxName);
//   return box.values.toList();
//   //final counterModel = CounterModel(id: "16-3-2022", count: 12);
//   //return List.filled(200, counterModel);
// }

// // Future<int> addCounter(DateTime date) async {
//   // firebase
//   //hive original code
//   var box = await Hive.openBox<CounterModel>(hiveCounterBoxName);
//   final CounterModel currentCounter =
//       await getCounterForDay(DateTime.now().month, DateTime.now().day);
//   final updatedCounter = (currentCounter.count) + 1;
//   final counterModel = CounterModel(
//     count: updatedCounter,
//     id: currentCounter.id,
//   );
//   box.put(counterModel.key ?? counterModel.id, counterModel);
//   return updatedCounter;
// }

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

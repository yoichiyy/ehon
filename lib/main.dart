import 'package:counter/models/constants.dart';
import 'package:counter/models/counter_model.dart';
import 'package:counter/models/task_model.dart';
import 'package:counter/models/database_provider.dart';
import 'package:counter/ui/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home_page.dart';
import 'package:path_provider/path_provider.dart';


//

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final directory = await getApplicationDocumentsDirectory();

  Hive
    ..init(directory.path)
    ..registerAdapter(CounterModelAdapter())
    ..registerAdapter(TaskModelAdapter()); //コピーof Example

  // final count = await addCounter(DateTime.now());//?? await。。何を通信している？
  // debugPrint("The current count is $count");
  runApp(const MyApp());
}

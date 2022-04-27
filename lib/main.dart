import 'package:counter/configs/constants.dart';
import 'package:counter/models/counter_model.dart';
import 'package:counter/models/task_model.dart';
import 'package:counter/providers/database/database_provider.dart';
import 'package:counter/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'ui/pages/home/home_page.dart';
import 'package:path_provider/path_provider.dart';

//

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();

  Hive
    ..init(directory.path)
    ..registerAdapter(CounterModelAdapter())
    ..registerAdapter(TaskModelAdapter()); //コピーof Example

  // final count = await addCounter(DateTime.now());//?? await。。何を通信している？
  // debugPrint("The current count is $count");
  runApp(const MyApp());
}

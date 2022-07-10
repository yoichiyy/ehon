import 'package:flutter/material.dart';
import 'funiv_main_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';

class TaskListPage extends StatefulWidget {
  //StatefulWidgetへの直し方
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ehonタスク',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<MainModel>(
        create: (_) => MainModel()..getTodoListRealtime(),
        child: Scaffold(
            bottomNavigationBar: BottomBar(currentIndex: 1),
            appBar: AppBar(
              title: Text('FUNIV TODOアプリ'),
            ),
            body: Consumer<MainModel>(
              builder: (context, model, child) {
                final todoList = model.todos;

                //todoList.map(e...)とやれば、e.taskNameとできるのに、　直接todoList.tasknameとできない。

//ListView.builder：todoList.taskNameと、読み込むことができない    
                return ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: ValueKey(todoList[index]), 
                      child: ListTile(
                        title: Text( 'Item ${todoList[index].taskName}'),//index]だと何故、itemInstanceとなってしまう？indexだから番号0,1,2...じゃないのか？
                      ),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        setState(() {
                          // todoList.removeAt(todoList[index]);//intを入手する方法？
                        });
                      },
                    );
                  },
                );


// //ListView：setStateで、indexつけることができずに困ってる。
//               return ListView(
//                 children: todoList.map((e) { //enumalated? → hukuzatsu google
//                   return Dismissible(
//                     key: ValueKey(e.taskName), //あっているのか？？？
//                     child: ListTile(
//                       title: Text(e.taskName),
//                     ),
//                     background: Container(color: Colors.red),
//                     onDismissed: (direction) {
//                       setState(() {
//                         // todoList.removeAt(e.taskName);
//                       });
//                     },
//                   );
//                 }).toList(),
//               );
              },

              // => Text(todoList.taskName)).toList(),
            )),
      ),
    );
  }
}

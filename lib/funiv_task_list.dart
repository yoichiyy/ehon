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

            return ListView(
              children: todoList
                          .map((todoLlist) => ListTile(title:Text(todoList.taskname),),).toList(),
                            // Dismissible(
                            //   background: Container(
                            //     color: Colors.green,
                            //   ),
                            //   key: ValueKey(todoList[index]),
                            //   onDismissed: (DismissDirection direction) {
                            //     setState(
                            //       () {
                            //         todoList.removeAt(
                            //             index); //同じ。itemsとindexにあたる部分をどう書けばよいのだろう。
                            //       },
                            //     );
                            //   },
                            //   child:
                          //     ListTile(
                          //       title: Text(e.taskName),
                          //     ),
                          //   ),
                          // )
                          // .toList(),
                    );
              
              
              


    //いったんコメントアウト。うまく言ってる？無限ループのリスト
                // return ListView.builder(
                //   //都度描画する・・・ここしっかり理解。名前暗記。
                //   itemCount: todoList.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return ListView(
                //       children: todoList
                //           .map(
                //             (e) => Dismissible(
                //               background: Container(
                //                 color: Colors.green,
                //               ),
                //               key: ValueKey(todoList[index]),
                //               onDismissed: (DismissDirection direction) {
                //                 setState(
                //                   () {
                //                     todoList.removeAt(
                //                         index); //同じ。itemsとindexにあたる部分をどう書けばよいのだろう。
                //                   },
                //                 );
                //               },
                //               child: ListTile(
                //                 title: Text(e.taskName),
                //               ),
                //             ),
                //           )
                //           .toList(),
                //     );
                //   },
                // );
              },
            )),
      ),
    );
  }
}

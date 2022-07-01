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

            //todo: builder内の　３つの引数は、どこから情報を受け取っている？
            body: Consumer<MainModel>(
              builder: (context, model, child) {
                final todoList = model.todoList;
                List<int> items = List<int>.generate(20, (int index) => index);
                return ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                          background: Container(
                            color: Colors.green,
                          ),
                          key: ValueKey<int>(items[index]),
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              items.removeAt(
                                  index); //同じ。itemsとindexにあたる部分をどう書けばよいのだろう。
                            });
                          },
                          child: ListView(
                            children: todoList
                                .map(
                                  (e) => ListTile(
                                    title: Text(e.taskName),
                                  ),
                                )
                                .toList(),
                          ));
                    });
              },
            )),
      ),
    );
  }
}

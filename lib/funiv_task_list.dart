import 'package:cloud_firestore/cloud_firestore.dart';
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
                final todos = model.todos;

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = todos[index];
                    return Dismissible(
                      key: ValueKey(todo),
                      child: ListTile(
                        title: Text('Item ${todo.taskName}'),
                      ),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        setState(
                          () {
                            //removeAtと、Firebaseのdelete両方をやる必要あるのかな？後者だけで良い感じも。→試してみる。
                            todos.removeAt(index);
                            FirebaseFirestore.instance
                                .collection('todoList')
                                .doc(todo.id)
                                .delete(); //そもそもこれは、doc.idがないので、おそらく動かぬ。
                          },
                        );
                      },
                    );
                  },
                );
              },
            )),
      ),
    );
  }
}

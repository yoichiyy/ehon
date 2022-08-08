import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../edit_task/edit_task.dart';
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
      title: 'ehon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<MainModel>(
        create: (_) => MainModel()..getTodoListRealtime(),
        child: Scaffold(
            bottomNavigationBar: BottomBar(currentIndex: 0),
            appBar: AppBar(
              title: Text('やること'),
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
                      child: InkWell(
                        onTap: () async{
                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskPage(todo),
                            ),
                          );
                          debugPrint("dismissible List クリックしました");
                        },
                        child: ListTile(
                          title: Text(
                              '${todo.taskName} ${todo.dueDate} ${todo.dueTime}'),
                        ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/task_list/todo_class.dart';
import 'package:flutter/material.dart';
import '../edit_task/edit_task.dart';
import 'task_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  // final Todo todo;
  // const EditTaskPage(this.todo, {Key? key}) : super(key: key);
  

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
                        onTap: () async {
                          //ここでString title = ...とやっていることが理解できぬ。この
                          //title変数を、次のeditTaskページに渡しているようにも見えない。
                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskPage(todo),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                              '${todo.taskNameOfTodoClass}　${model.todo.createdAt?.month}/${model.todo.createdAt?.day}  ${model.todo.createdAt?.hour}時'),
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

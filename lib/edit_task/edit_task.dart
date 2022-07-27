// import 'package:book_list_sample/domain/book.dart';
// import 'package:book_list_sample/edit_book/edit_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../funiv_main_model.dart';
import '../todo.dart';
import 'edit_task_model.dart';

class EditTaskPage extends StatelessWidget {
  final Todo todo;
  EditTaskPage(this.todo);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTaskModel>(
      create: (_) => EditTaskModel(todo), //F質問：この顔文字のようなものは何だ…
      child: Scaffold(
        appBar: AppBar(
          title: Text('タスクを編集'),
        ),
        body: Center(
          child: Consumer<EditTaskModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.titleController,
                    decoration: InputDecoration(
                      hintText: 'タスク名',
                    ),
                    onChanged: (text) {
                      model.setTaskName(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.authorController,
                    decoration: InputDecoration(
                      hintText: '日付',
                    ),
                    onChanged: (text) {
                      model.setDueDate(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            // 追加の処理
                            try {
                              await model.update();
                              Navigator.of(context).pop(model.taskName);
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: Text('更新する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

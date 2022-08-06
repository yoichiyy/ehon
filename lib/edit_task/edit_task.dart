// import 'package:book_list_sample/domain/book.dart';
// import 'package:book_list_sample/edit_book/edit_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
          title: const Text('タスクを編集'),
        ),
        body: Center(
          child: Consumer<EditTaskModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //datetimepicker　はりつけ
                  TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2022, 3, 5),
                          maxTime: DateTime(2025, 6, 7), onChanged: (date) {
                        debugPrint('change $date');
                      }, onConfirm: (date) {
                        model.updateTimestamp(date);
                        //timestampのタイプを変更検討
                        //viewとmodel　更新系＝モデルでやるべし。notifilistenersたたけないから。
                        

                        debugPrint('confirm $date');
                      }, currentTime: DateTime.now(), locale: LocaleType.jp);
                    },
                    child: const Text(
                      'DATETIME PICKER',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  // Text("${model.dateTimeController}"),
                  Text("${model.todo.timestamp!.toDate()}"),

                  // controller: model.dateTimeController,
                  // onChanged: (text) {
                  //   model.setTaskName(text);
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.dateTimeController,
                    decoration: const InputDecoration(
                      hintText: '日付',
                    ),
                    onChanged: (text) {
                      model.setDueDate(text);
                    },
                  ),
                  const SizedBox(
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
                    child: const Text('更新する'),
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

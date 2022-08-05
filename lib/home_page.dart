import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/homeCard.dart';
import 'package:counter/main.dart';
import 'package:counter/models/database_provider.dart';
import 'package:counter/navigation.dart';
import 'package:counter/history_page.dart';
import 'package:counter/%E5%89%8A%E9%99%A4OK/%E3%83%BB%E3%83%BB%E3%83%BBtask_list_page.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'models/counter_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final _controller = TextEditingController();
  // int countToday = 0;
  // void _incrementCounter() async {
  //   await addCounter(DateTime.now());
  //   setState(() {
  //     countToday++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("ehon"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: HomeCardWidget(
              title: "えほん",
              color: Colors.red.withOpacity(0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _countArea(),
                  Center(
                    child: _buttonArea(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: HomeCardWidget(
              title: "TODO",
              color: Colors.blue.withOpacity(0.2),
              child: const TaskCard(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 1),
    );
  }

  Widget _countArea() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: FutureBuilder<int>(
                  future: getCounterForDay(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "今日: ${snapshot.data}",
                        // "Today: ${snapshot.data?.bookTitles?.join(", ") ?? "No book data"}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    );
                  }),
              // const Text("Total Today"),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: FutureBuilder<int>(
                // future: getCounterForDay(DateTime.now()),
                future: getCounterForMonth(
                    //ここで、DEBUGしても、yearとmonthは確認できないんだろうか。FQ：
                    DateTime.now().year,
                    DateTime.now().month),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "今月: ${snapshot.data}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: FutureBuilder<int>(
                  // future: getCounterForDay(DateTime.now()),
                  future: getCounterForAll(),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "全部: ${snapshot.data}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonArea() {
    return SizedBox(
      width: 60,
      height: 60,
      child: FloatingActionButton(
        onPressed: () async {
          debugPrint("ehonカウント送信 to Fire");
          await FirebaseFirestore.instance
              .collection('ehoncount')
              .doc() // ドキュメントID自動生成
              .set({
            'ehon_year': "${DateTime.now().year}",
            'ehon_month': "${DateTime.now().month}",
            'ehon_date': "${DateTime.now().day}",
            'ehon_pm': "plus"
          });
          // _incrementCounter(); hive
        },
        heroTag: "Increment",
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
    );
  }
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   _controller.dispose();
  //   super.dispose();
  // }
}

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key}) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final TextEditingController _controller = TextEditingController();
  DateTime _pickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
//１．singlechild scroll view　→　すくろールできるようにする方法もある。
//expanded 1:2　になってるので、これをやめないと。高さを固定するなど。

                        controller: _controller,
                        decoration: const InputDecoration(hintText: "やること"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final _result = await showDatePicker(
                          context: context,
                          currentDate: _pickedDate,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 0)),
                          lastDate: DateTime.now().add(
                            const Duration(days: 3 * 365),
                          ),
                        );
                        if (_result != null) {
                          _pickedDate = _result;
                        }

                        setState(() {});
                      },
                      child: Text("日付指定"),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _pickedDate = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day + 1,
                              DateTime.now().hour,
                              DateTime.now().minute,
                            ));
                        debugPrint(_pickedDate.toString());
                      },
                      child: const Text("明日"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _pickedDate = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day + 7,
                              DateTime.now().hour,
                              DateTime.now().minute,
                            ));
                        debugPrint(_pickedDate.toString());
                      },
                      child: const Text("来週"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _pickedDate = DateTime(
                              DateTime.now().year,
                              DateTime.now().month + 1,
                              DateTime.now().day,
                              DateTime.now().hour,
                              DateTime.now().minute,
                            ));
                        debugPrint(_pickedDate.toString());
                      },
                      child: const Text("来月〜"),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _pickedDate = DateTime(
                              _pickedDate.year,
                              _pickedDate.month,
                              _pickedDate.day,
                              6,
                            ));
                        debugPrint(_pickedDate.toString());
                      },
                      child: const Text("朝"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _pickedDate = DateTime(
                              _pickedDate.year,
                              _pickedDate.month,
                              _pickedDate.day,
                              12,
                            ));
                        debugPrint(_pickedDate.toString());
                      },
                      child: const Text("昼"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _pickedDate = DateTime(
                              _pickedDate.year,
                              _pickedDate.month,
                              _pickedDate.day,
                              19,
                            ));
                        debugPrint(_pickedDate.toString());
                      },
                      child: const Text("夜"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),

        //これも、上のexpandedの中にどうして入れることができないか？
        MaterialButton(
          color: Colors.green,
          onPressed: () async {
            if (_controller.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Oops"),
                    content: const Text("You need to add a task"),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              return;
            } //if
            await FirebaseFirestore.instance
                .collection('todoList') // コレクションID指定
                .doc() // ドキュメントID自動生成
                .set({
              'title': _controller.value.text, //stringを送る
              'createdAt': _pickedDate //本当はタイムスタンプ　「サーバー　タイムスタンプ」検索
            });
            debugPrint("登録しました");
          },
          child: const Text("登録"),
        ),
      ],
    );
  }
}

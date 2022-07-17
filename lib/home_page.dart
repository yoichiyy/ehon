import 'package:cloud_firestore/cloud_firestore.dart';
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

  final _controller = TextEditingController();

  int _countToday = 0;
  void _incrementCounter() async {
    await addCounter(DateTime.now(), _controller.text);
    setState(() {
      _countToday++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("ehon"),
      // ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
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
            flex: 2,
            child: HomeCardWidget(
              title: "TODO",
              color: Colors.amber.withOpacity(0.2),
              child: const TaskCard(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 0),
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
              child: FutureBuilder<CounterModel>(
                  future: getCounterForDay(DateTime.now()),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "今日: ${snapshot.data?.count}",
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
                      DateTime.now().month, DateTime.now().year),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "今月: ${snapshot.data}",
                        // "Today: ${snapshot.data?.bookTitles?.join(", ") ?? "No book data"}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    );
                  }),
              // const Text("Total Today"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonArea() {
    return Expanded(
      child: Container(
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              _incrementCounter();
            },
            heroTag: "Increment",
            tooltip: "Increment",
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showBookDialog(String title, String content) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
  }
}

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget(
      {Key? key, required this.color, required this.title, required this.child})
      : super(key: key);

  final Color color;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Flexible(
                child: Center(child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      //2
                      onPressed: () {},
                      child: const Text("ON"),
                    ),
                    ElevatedButton(
                      //2
                      onPressed: () {},
                      child: const Text("OFF"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
              'text': _controller.value.text, //stringを送る
              'date': _pickedDate //本当はタイムスタンプ　「サーバー　タイムスタンプ」検索
            });
            debugPrint("登録しました");
          },
          child: const Text("登録"),
        ),
      ],
    );
  }
}

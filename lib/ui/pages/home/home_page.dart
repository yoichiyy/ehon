import 'package:counter/main.dart';
import 'package:counter/providers/database/database_provider.dart';
import 'package:counter/ui/navigation/navigation.dart';
import 'package:counter/ui/pages/history/history_page.dart';
import 'package:counter/ui/pages/task_list/task_list_page.dart';
import 'package:counter/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../../models/counter_model.dart';

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
      appBar: AppBar(
        title: const Text("ehon"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: HomeCardWidget(
              title: "Book Count",
              color: Colors.red.withOpacity(0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: _countArea()),
                  Center(
                    child: _buttonArea(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: HomeCardWidget(
              title: "Tasks",
              color: Colors.amber.withOpacity(0.2),
              child: TaskCard(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(currentIndex: 0),
    );
  }

  Widget _countArea() {
    return Container(
      margin: EdgeInsets.all(10),
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
                        "Today: ${snapshot.data?.count}",
                        // "Today: ${snapshot.data?.bookTitles?.join(", ") ?? "No book data"}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
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
                        "Today: ${snapshot.data}",
                        // "Today: ${snapshot.data?.bookTitles?.join(", ") ?? "No book data"}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
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
          width: 100,
          height: 100,
          child: FloatingActionButton(
            onPressed: () {
              // if (_formKey.currentState?.validate() ?? false) {
              _incrementCounter();
              // _formKey.currentState?.reset();
              // _showBookDialog("Success!", "You've added a book!");
              // } else {
              //   _showBookDialog("Warning", "You need to put a book.");
              // }
            },
            heroTag: "Increment",
            tooltip: "Increment",
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  // children: [
  //   SizedBox(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.all(50.0),
  //           child: Form(
  //             key: _formKey,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 TextFormField(
  //                   controller: _controller,
  //                   decoration: const InputDecoration(
  //                     hintText: "Enter the title",
  //                   ),
  //                   validator: (String? value) {
  //                     if (value == null || value.isEmpty) {
  //                       return "Please enter some text";
  //                     }
  //                     return null;
  //                   },
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //         ],
  //       ),
  //     ),
  //   ],
  // ),

  // git hub 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
  //どうして、右下に配置される？bodyでなければ、この場所はなんと呼ばれている？
  //   );
  // }

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
              Expanded(
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
            child: Row(
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
                        firstDate: DateTime.now().subtract(Duration(days: 0)),
                        lastDate: DateTime.now().add(
                          Duration(days: 3 * 365),
                        ),
                      );
                      if (_result != null) {
                        _pickedDate = _result;
                      }

                      setState(() {});
                    },
                    child: Text(_pickedDate == null
                        ? "期日"
                        : "${_pickedDate.month} - ${_pickedDate.day}"))
              ],
            ),
          ),
        ),
        MaterialButton(
          color: Colors.green,
          onPressed: () {
            if (_pickedDate == null || _controller.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Oops"),
                    content: Text("You need to add a task"),
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
            }

            addTask(_pickedDate!, _controller.text);
          },
          child: Text("ADD TASK"),
        ),
      ],
    );
  }
}

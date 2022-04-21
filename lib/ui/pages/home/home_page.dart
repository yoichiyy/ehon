import 'package:counter/main.dart';
import 'package:counter/providers/database/database_provider.dart';
import 'package:counter/ui/navigation/navigation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _controller = TextEditingController();
  void _incrementCounter() async {
    await addCounter(DateTime.now(), _controller.text);
  } //ここで、わざわざ別の関数を呼び出すことに意味はあるのか？

  void _navigateToHistory() {
    navigateToHistory(context);
  }

//1.swipe to the "right" page (history)
//2.左上に今月のトータル冊数
//3.右上に今日のトータル冊数
//4.タイトル入力は必須ではない
//5.右下のナビゲーションボタンは削除
//6.左にやることリストを作る
//7.左下に小さな登録ボタン。こちらを押した場合はTODOとして追加される。
//8.テキスト入力欄が左下のボタンの上に移動
//9.TODOはスライドで次々削除していくことができる。
//10.


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("絵本"),
      ),
      //やっぱbodyの中だろう。centerの中で、問題ないだろう。
      body: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // どういうときにchildで、childrenなのか？
            // <widget>となるときもある。この＜＞は何なのか？
            // コラムでこのボックスと、フォームをくくると思うんだけど、できるかな。
            // wrap with columnというコマンドが出てくる、ショートカットは何だっけ option + return
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Enter the title",
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    // true?  false??
                    if (_formKey.currentState?.validate() ?? false) {
                      _incrementCounter();
                      _formKey.currentState?.reset();
                      _showBookDialog("Success!", "You've added a book!");
                    } else {
                      _showBookDialog("Warning", "You need to put a book.");
                    }
                  },
                  heroTag: "Increment",
                  tooltip: "Increment",
                  child: const Icon(Icons.add),
                  // materialTapTargetSize: ,
                ),
              ),
            ],
          )),
      //どうして、右下に配置される？bodyでなければ、この場所はなんと呼ばれている？
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          onPressed: _navigateToHistory,
          heroTag: "Navigate",
          tooltip: "Navigate",
          backgroundColor: Colors.red,
          child: const Icon(Icons.note),
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

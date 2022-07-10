import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Delete List Item',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SamplePage1(),
    );
  }
}

class SamplePage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SamplePage1State();

}

class SamplePage1State extends State<SamplePage1> {
  final _data = ['data1', 'data2', 'data3', 'data4', 'data5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sample Page 1')),
      body: ListView(
        children: _data.map((text) {
          return Dismissible(
            key: Key(text),
            child: ListTile(
              title: Text(text),
            ),
            background: Container(color: Colors.red),
            confirmDismiss: (direction) async {
              // ここで確認を行う
              // Future<bool> で確認結果を返す
              // False の場合削除されない
              return text != 'data3';
            },
            onDismissed: (direction) {
              // 削除アニメーションが完了し、リサイズが終了したときに呼ばれる
              setState(() {
                _data.removeWhere((t) => t == text);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
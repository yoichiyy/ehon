import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomBar(currentIndex: 2),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Colors.blue.shade100.withOpacity(0.2),
              Colors.red.shade500.withOpacity(0.2)
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          ],
        ),
      ),
    );
  }
}

class ListTileText extends StatelessWidget {
  final String title;
  final String text;
  const ListTileText({required this.title, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
      TextSpan(text: "$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: text),
    ]));
  }
}


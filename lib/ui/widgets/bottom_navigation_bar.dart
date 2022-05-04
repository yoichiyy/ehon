import 'package:counter/ui/pages/history/history_page.dart';
import 'package:counter/ui/pages/home/home_page.dart';
import 'package:counter/ui/pages/task_list/task_list_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: "Tasks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "Books",
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyHomePage()));
        }

        if (index == 1) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TaskListPage()));
        }

        if (index == 2) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HistoryPage()));
        }
      },
    );
  }
}

import 'package:counter/main.dart';
import 'package:counter/models/counter_model.dart';
import 'package:counter/models/task_model.dart';
import 'package:counter/providers/database/database_provider.dart';
import 'package:counter/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomBar(currentIndex: 1) ,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Colors.blue.shade100.withOpacity(0.2),
              Colors.red.shade500.withOpacity(0.2)
            ])),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                )),
            child: FutureBuilder<List<TaskModel>>(
                future: getAllTasks(),
                builder: (context, snapshot) {
                  // Check if we have DATA
                  if (snapshot.hasData) {
                    final listOfTasks = snapshot.data;

                    /// When we use a ListView, it will try to EXPAND in height
                    /// as  much as it can
                    ///
                    /// SO we need to CONSTRAINT it's height by saying "Hey!  you can only have this much height"
                    ///
                    /// If we are inside a Column we have two options:
                    ///
                    /// 1. Either we　wrap the ListView with a widget that CONSTRAINTS the height
                    /// 2. We use the "shrinkWrap" property of the ListView so that it tries to
                    /// shrink as much as it can
                    /// 3. We put the ListView inside an Expanded Widget that will tell the Column
                    /// "Hey I will ocupy the REMAINING space available"
                    return Scrollbar(
                      isAlwaysShown: true,
                      child: ListView.builder(
                        /// If we don't know if the receiver is NULL or NOT NULL (this is
                        /// seen every time  that a TYPE ends with a ? like String?) then
                        /// we NEED to tell Dart when we are SURE that it's not null "Hey, this is NOT NULL!!!"
                        /// See the exclamation mark at the end? That's exactly what we need to use
                        ///
                        /// So if we have a:
                        /// String? name;
                        ///
                        /// And we want to use it inside a TEXT and we KNOW it's not null, we do:
                        ///
                        /// if (name != null) {
                        ///     return Text(name!);
                        /// }
                        itemCount: listOfTasks!.length,
                        itemBuilder: (context, index) {
                          final date = listOfTasks[index].date;
                          final task = listOfTasks[index].title;
                          return Card(
                            margin: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              bottom: 20,
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  ListTileText(
                                      title: "Date", text: "${date.month}/${date.day}/${date.year}"),
                                  ListTileText(title: "Title", text: task),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const Center(
                    child: Text("We have no data :("),
                  );
                }),
          ),
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

class Animal {
  final String name;

  Animal(this.name);
}

/// Inheritnce - we are going to EXTEND a class, and get properties from that class.
/// We call the class we EXTEND, the PARENT, and the other could be called "child"
///
/// In order to do this in Dart, we need to use the  `extends`keyword when we are
/// creating a class. You can see this clearly when we use a Stateless or Stateful Widget
///
/// In the above example, we have an `Animal` class that only has a name
///
/// Our objective now is to create a Person class that will ALSO have a name, but also
/// other properties, such as profession
///
/// But this poses a problem - can Animal and Person have a name?
///
/// Yes! We say that we call the "SUPER" constructor, which means that we are saying
///
/// Hey, create a Person, that is in fact an Animal, with this ANIMAL NAME
///
/// So the SUPER, passes the properties to the parent

class Person extends Animal {
  final String profession;

  Person(this.profession, String name) : super(name);
}

import 'package:counter/configs/constants.dart';
import 'package:counter/models/counter_model.dart';
import 'package:hive/hive.dart';

Future<int> getCounterForMonth(int month, int year) async {
  var box = await Hive.openBox<CounterModel>(hiveBoxName);
  final values = box.values.toList();

  var count = 0;

  for (var counter in values) {
    /// 1. Get the date from the id
    final date = getDateFromId(counter.id);

    /// 2. If the date month and year match our query, then we
    /// add the value to the counter
    if (date.month == month && date.year == year) {
      /// This is the same as `count = count + counter.count;`
      count += counter.count;
    }
  }

  return count;
}

/// I want to get a CounterModel for a specific date
Future<CounterModel> getCounterForDay(DateTime date) async {
  var box = await Hive.openBox<CounterModel>(hiveBoxName);
  final values = box.values.toList();
  print(values);

  // 2.1 Create id from date
  // We know that the date is in the format day-month-year
  // so we can access the date varable and create this string
  final id = getIdFromDate(date);

  // I will need to retrieve exactly the CounterModel for the date, if avaible
  CounterModel? currentModel = box.get(id);

  return currentModel ??
      CounterModel(bookTitles: [], count: 0, id: getIdFromDate(date));
}

/// I want to get ALL counter models
Future<List<CounterModel>> getAllCounters() async {
  var box = await Hive.openBox<CounterModel>(hiveBoxName);
  return box.values.toList();
  //final counterModel = CounterModel(id: "16-3-2022", count: 12);
  //return List.filled(200, counterModel);
}

///　I want to create a a function that will update the value of counter by1
Future<int> addCounter(DateTime date, String bookTitle) async {
  var box = await Hive.openBox<CounterModel>(hiveBoxName);
  final CounterModel currentCounter = await getCounterForDay(date);

  /// 2. I want to add 1 to that number
  final updatedCounter = (currentCounter.count) + 1;
  // do the action & keep the type
  final updatedBookList = (currentCounter.bookTitles ?? <String>[])
    ..add(bookTitle);

  /// 3. I want to update the database with this new number
  final counterModel = CounterModel(
    count: updatedCounter,
    id: currentCounter.id,
    bookTitles: updatedBookList,
  );
  box.put(counterModel.key ?? counterModel.id, counterModel);
  return updatedCounter;
}

/// This receives a current [DateTime] object and converts it
/// to a specific database ID
///
/// DateTime -> ID
String getIdFromDate(DateTime date) {
  return "${date.day}-${date.month}-${date.year}";
}

/// Receives a DATABAS Id and converts it to a [DateTime] so that we know
/// what date this ID referes to
///
/// ID -> DateTime
DateTime getDateFromId(String id) {
  final getListOfNumbers = id.split("-").reversed.toList();
  return DateTime(int.parse(getListOfNumbers[0]),
      int.parse(getListOfNumbers[1]), int.parse(getListOfNumbers[2]));
}

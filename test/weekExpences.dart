import 'package:intl/intl.dart';

void main() {
  List expensesData = [
    ["Entertainment", 37.32, DateTime(2023, 12, 12)],
    ["Groceries", 14.71, DateTime(2023, 12, 16)],
    ["Groceries", 85.51, DateTime(2023, 12, 20)],
    ["Food", 74.32, DateTime(2023, 12, 19)],
    ["Entertainment", 12.49, DateTime(2023, 12, 14)],
    ["Utilities", 89.12, DateTime(2023, 12, 16)],
    ["Transport", 71.93, DateTime(2023, 12, 10)],
    ["Transport", 78.44, DateTime(2023, 12, 26)],
    ["Transport", 87.32, DateTime(2023, 12, 16)],
  ];

  var expensesOfWeek = getExpensesForCurrentWeek(expensesData);
  print(expensesOfWeek);
}

Map<String, double> getExpensesForCurrentWeek(List expensesData) {
  DateTime now = DateTime.now();
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

  Map<String, double> weeklyExpenses = {};

  // Initialize all days of the week with 0 expense
  for (int i = 0; i < 7; i++) {
    String day = DateFormat('E\ndd').format(startOfWeek.add(Duration(days: i)));
    weeklyExpenses[day] = 0.0;
  }

  for (var expense in expensesData) {
    double amount = expense[1];
    DateTime date = expense[2];

    if (date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(Duration(days: 1)))) {
      String formattedDate = DateFormat('E\ndd').format(date);
      weeklyExpenses.update(
          formattedDate, (currentTotal) => currentTotal + amount,
          ifAbsent: () => amount);
    }
  }

  return weeklyExpenses;
}

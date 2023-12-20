import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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

class Expense {
  final String expense;
  final double amount;
  final DateTime date;
  Expense({
    required this.expense,
    required this.amount,
    required this.date,
  });

// Function to put/update expenses data in Hive box
  Future<void> putExpensesInHiveBox(List expensesData) async {
    var box = await Hive.openBox('expensesBox');

    for (var i = 0; i < expensesData.length; i++) {
      await box.put('expense_$i', expensesData[i]);
    }
  }

// Function to get expenses data from Hive box
  Future<List> getExpensesFromHiveBox() async {
    var box = await Hive.openBox('expensesBox');
    List expensesData = [];

    box.keys.forEach((key) {
      var expense = box.get(key);
      expensesData.add(expense);
    });

    return expensesData;
  }

  // get the Expences of the curent Week Monday to Sunday
/*
  the Expences of the week should rturn as follow : 
   - get the List of Expences 
   - some logic 
   - Expence_of_the_week = 
   {
    "M\n12" : 656.1,
    ...
    S\n18 : 6776,85,
   }
*/
  Map<String, double> getExpensesForCurrentWeek(List expensesData) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    Map<String, double> weeklyExpenses = {};

    // Initialize all days of the week with 0 expense
    for (int i = 0; i < 7; i++) {
      String day =
          DateFormat('E\ndd').format(startOfWeek.add(Duration(days: i)));
      weeklyExpenses[day] = 0.0;
    }

    for (var expense in expensesData) {
      double amount = expense[1];
      DateTime date = expense[2];

      if (date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        String formattedDate = DateFormat('E\ndd').format(date);
        weeklyExpenses.update(
            formattedDate, (currentTotal) => currentTotal + amount,
            ifAbsent: () => amount);
      }
    }

    return weeklyExpenses;
  }

  // get the Expences of the current Month
  double getTotalExpensesForCurrentMonth(List expensesData) {
    DateTime now = DateTime.now();
    double total = 0.0;

    for (var expense in expensesData) {
      double amount = expense[1];
      DateTime date = expense[2];

      if (date.month == now.month && date.year == now.year) {
        total += amount;
      }
    }

    return total;
  }

  // get the Expences of the Day
  double getTotalExpensesForToday(List expensesData) {
    DateTime now = DateTime.now();
    double total = 0.0;

    for (var expense in expensesData) {
      double amount = expense[1];
      DateTime date = expense[2];

      if (date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        total += amount;
      }
    }

    return total;
  }
}

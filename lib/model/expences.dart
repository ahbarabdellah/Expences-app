import 'package:hive/hive.dart';

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
  }) {
    expensesData = getExpensesDate();
  }

  // getList of expences

  List getExpensesDate() {
    var box = Hive.box("myData");
    if (box.get("data") != null) {
      expensesData = box.get("data");
      return box.get("data");
    } else {
      return expensesData;
    }
  }
  // put the list of expences in the hive box
}

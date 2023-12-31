import 'package:expenses/model/expences.dart';
import 'package:expenses/widgets/add_expence_widget.dart';
import 'package:expenses/widgets/total_spent_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../widgets/graphs.dart';
import '../widgets/item_expence_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//TODO:remove logic from all the functions ;
//TODO:crete a model ;
//TODO:fix isses;
//TODO:dispose the cotrolers;
//TODO:Add a Hive Local Storage;
//TODO:clean the Dialog after uing;
//TODO:Publish the APP

class _MyHomePageState extends State<MyHomePage> {
  List<double> weeklyExpense = List.generate(7, (_) => 0.0);

  double daySpend = 0;
  double weekSpend = 0;
  double monthSpend = 0;

  List monthlyExpenses = [];
  List weeklyExpenses = [];
  List dailyExpenses = [];

  void calculateWeeklyExpenses(List<dynamic> expensesData) {
    DateTime today = DateTime.now();
    // Adjust startOfWeek to be the most recent Monday
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    for (var expense in expensesData) {
      double amount = expense[1];
      DateTime date = expense[2];

      if (date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        int dayIndex = date.difference(startOfWeek).inDays;
        setState(() {
          weeklyExpense[dayIndex] += amount;
        });
      }
    }
  }

  final DateTime _selectedDate = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController dolarControler = TextEditingController();
  TextEditingController centControler = TextEditingController();

  void savetransaction() {
    setState(() {
      expensesData.add([
        nameController.text.trim(),
        double.parse(
            "${dolarControler.text.trim()}.${centControler.text.trim()}"),
        _selectedDate
      ]);
    });
  }

  @override
  void initState() {
    calculateSpent();
    calculateWeeklyExpenses(expensesData);
    super.initState();
  }

  void calculateSpent() {
    // Get today's date
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(
        days: today.weekday % 7)); // Saturday is considered start of the week
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    setState(() {
      for (List expense in expensesData) {
        if (expense[2].year == today.year && expense[2].month == today.month) {
          monthlyExpenses.add(expense);
        }
        if (expense[2].isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            expense[2].isBefore(endOfWeek.add(const Duration(days: 1)))) {
          weeklyExpenses.add(expense);
        }
        if (expense[2].year == today.year &&
            expense[2].month == today.month &&
            expense[2].day == today.day) {
          dailyExpenses.add(expense);
        }
      }
    });

    setState(() {
      daySpend = 0;
      monthSpend = 0;
      weekSpend = 0;
      for (var element in dailyExpenses) {
        daySpend += element[1];
      }
      for (var element in monthlyExpenses) {
        monthSpend += element[1];
      }
      for (var element in weeklyExpenses) {
        weekSpend += element[1];
      }
    });

    // Now you have monthlyExpenses, weeklyExpenses, and dailyExpenses populated accordingly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              TotalSpendingWidget(
                mountSpend: monthSpend,
                weekSpend: weekSpend,
                daySpend: daySpend,
              ),
              BarGraph(weekExpences: weeklyExpense),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Expences",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                // Use Expanded here for the ListView
                child: ListView.builder(
                  itemCount: expensesData.length,
                  itemBuilder: (context, index) {
                    List expense =
                        expensesData[expensesData.length - index - 1];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Slidable(
                          endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(10),
                                  padding: const EdgeInsets.only(bottom: 10),
                                  onPressed: (context) {
                                    setState(() {
                                      expensesData.remove(expense);
                                    });
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ]),
                          child: ItemExpenceWidget(expence: expense)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialg(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  Future<dynamic> showDialg(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExpenseDialog(
          nameController: nameController,
          dolarControler: dolarControler,
          centControler: centControler,
          selectedDate: _selectedDate,
          update: update,
        );
      },
    );
  }

  void update() {
    savetransaction();
    calculateSpent();
    calculateWeeklyExpenses(expensesData);
  }
}

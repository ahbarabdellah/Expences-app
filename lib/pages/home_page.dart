import 'package:expenses/model/expences.dart';
import 'package:flutter/material.dart';

import '../widgets/graphs.dart';
import '../widgets/item_expence_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double daySpend = 0;
  double weekSpend = 0;
  double monthSpend = 0;

  List monthlyExpenses = [];
  List weeklyExpenses = [];
  List dailyExpenses = [];

  var expensesData = [
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

  DateTime _selectedDate = DateTime.now();
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
    // TODO: implement initState
    calculateSpent();
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
      for (var element in dailyExpenses) {
        daySpend += element[1];
        print(daySpend);
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

// Call this function when you need to show the dialog.
  void showCustomContentDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Add an Expense"),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'name'),
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: dolarControler,
                      decoration: const InputDecoration(hintText: 'dollars'),
                    )),
                    const SizedBox(
                        width: 10), // Add a gap between the text fields
                    Expanded(
                        child: TextField(
                      controller: centControler,
                      decoration: const InputDecoration(hintText: 'cents'),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)),
                        child: MaterialButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DatePickerDialog(
                                  initialDate:
                                      DateTime.now(), // Set an initial date
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 50)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 50)),
                                );
                              },
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                // Handle the selected date
                                _selectedDate = selectedDate;
                                calculateSpent();
                              }
                            });
                          },
                          child: const Text(
                            'Select a Date',
                            style: TextStyle(color: Colors.white),
                          ), // Add a child to MaterialButton to show something on the button
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(), // Closes the dialog
            ),
            TextButton(
                child: const Text("Save"),
                onPressed: () {
                  savetransaction();
                  Navigator.of(context).pop(); // Closes the dialog
                }),
          ],
        );
      },
    );
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
              BarGraph(),
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
                    return ItemExpenceWidget(expence: expense);
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
          showCustomContentDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}

class TotalSpendingWidget extends StatelessWidget {
  const TotalSpendingWidget({
    super.key,
    required this.mountSpend,
    required this.weekSpend,
    required this.daySpend,
  });

  final double daySpend;
  final double weekSpend;
  final double mountSpend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "Total Day Spent :",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "${daySpend}",
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("\$", style: TextStyle(fontSize: 20))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "Total Week Spent :",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "${weekSpend}",
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("\$", style: TextStyle(fontSize: 20))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "Total month Spent :",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "${mountSpend}",
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("\$", style: TextStyle(fontSize: 20))
          ]),
        ],
      ),
    );
  }
}

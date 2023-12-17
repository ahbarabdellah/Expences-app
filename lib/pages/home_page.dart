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
  double week_spend = 100.25;
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

  Widget customContent = const SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Add an Expense"),
        TextField(
          decoration: InputDecoration(hintText: 'name'),
        ),
        Row(
          children: [
            Expanded(
                child: TextField(
              decoration: InputDecoration(hintText: 'dollars'),
            )),
            SizedBox(width: 10), // Add a gap between the text fields
            Expanded(
                child: TextField(
              decoration: InputDecoration(hintText: 'cents'),
            )),
          ],
        ),
        // Additional content...
      ],
    ),
  );

// Call this function when you need to show the dialog.
  void showCustomContentDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: customContent,
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(), // Closes the dialog
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () => Navigator.of(context).pop(), // Closes the dialog
            ),
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
              TotalSpendingWidget(week_spend: week_spend),
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
                    List expense = expensesData[index];
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
    required this.week_spend,
  });

  final double week_spend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(children: [
        const Text(
          "Total Spent :",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "${week_spend}",
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text("\$", style: TextStyle(fontSize: 20))
      ]),
    );
  }
}

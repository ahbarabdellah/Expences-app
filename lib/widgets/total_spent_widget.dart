import 'package:flutter/material.dart';

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
              daySpend.toStringAsFixed(2),
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
              weekSpend.toStringAsFixed(2),
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
              mountSpend.toStringAsFixed(2),
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

import 'dart:ffi';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatefulWidget {
  List<double> weekExpences;
  BarGraph(
      {super.key, this.weekExpences = const [100.2, 50, 30, 10, 32.54, 0]});

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  double maxExpence = 100;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade400,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var index = 0; index < widget.weekExpences.length; index++)
            CostumBarChart(
              index: index,
              expence: widget.weekExpences[index],
              maxExpence: 100,
            ),
        ],
      ),
    );
  }

  void getMaxExpence() {
    var sorted = widget.weekExpences;
    sorted.sort();
    setState(() {
      maxExpence = sorted[0];
    });
  }
}

class CostumBarChart extends StatelessWidget {
  final int index;
  final double expence;
  final double maxExpence;

  const CostumBarChart({
    super.key,
    required this.index,
    required this.expence,
    required this.maxExpence,
  });
  double getHight(double expense) {
    if (expense == 0) {
      return 0.0;
    } else {
      return ((expense / maxExpence) * 250) * 0.9;
    }
  }

  String getTitle(int index) {
    String text;
    switch (index) {
      case 0:
        text = 'Mon'; // Monday
        break;
      case 1:
        text = 'Tue'; // Tuesday
        break;
      case 2:
        text = 'Wed'; // Wednesday
        break;
      case 3:
        text = 'Thu'; // Thursday
        break;
      case 4:
        text = 'Fri'; // Friday
        break;
      case 5:
        text = 'Sat'; // Saturday
        break;
      case 6:
        text = 'Sun'; // Sunday
        break;
      default:
        text = '';
        break;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.black),
          height: 250,
          width: 20,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              width: 20,
              height: getHight(expence),
            ),
          ),
        ),
        Text(
          getTitle(index),
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        )
      ]),
    );
  }
}

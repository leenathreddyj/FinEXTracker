import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions; // Transactions for FinEXTracker
  double _totalSpending = 0.0; // Total spending for the week

  Chart(this._recentTransactions, {super.key});

  // Groups transactions by day for the past week and calculates totals
  List<Map<String, Object>> get groupedTransactionValues {
    final today = DateTime.now();
    List<double> weekSums = List<double>.filled(7, 0);

    for (Transaction txn in _recentTransactions) {
      weekSums[txn.txnDateTime.weekday - 1] += txn.txnAmount;
      _totalSpending += txn.txnAmount;
    }

    return List.generate(7, (index) {
      final dayOfPastWeek = today.subtract(
        Duration(days: index),
      );

      return {
        'day': DateFormat('E').format(dayOfPastWeek)[0], // First letter of day (e.g., 'M' for Monday)
        'amount': weekSums[dayOfPastWeek.weekday - 1], // Daily spending amount
      };
    }).reversed.toList(); // Reverse to show most recent day last
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((value) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                value['day'] as String, // Day label (e.g., 'M', 'T')
                value['amount'] as double, // Spending amount for that day
                _totalSpending == 0.0
                    ? 0.0
                    : (value['amount'] as double) / _totalSpending, // Percentage of total
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
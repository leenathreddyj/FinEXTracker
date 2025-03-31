import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions; // Transactions for FinEXTracker

  const Chart(this._recentTransactions, {super.key}); // Added const

  // Groups transactions by day for the past week and calculates totals
  List<Map<String, Object>> get groupedTransactionValues {
    final today = DateTime.now();
    List<double> weekSums = List<double>.filled(7, 0);
    double totalSpending = 0.0; // Local variable instead of field

    for (Transaction txn in _recentTransactions) {
      weekSums[txn.txnDateTime.weekday - 1] += txn.txnAmount;
      totalSpending += txn.txnAmount; // Calculate total here
    }

    return List.generate(7, (index) {
      final dayOfPastWeek = today.subtract(Duration(days: index));
      final day = DateFormat('E').format(dayOfPastWeek)[0]; // First letter of day
      final amount = weekSums[dayOfPastWeek.weekday - 1]; // Daily spending amount
      final pct = totalSpending == 0.0 ? 0.0 : amount / totalSpending; // Percentage

      return {
        'day': day, // String (non-nullable)
        'amount': amount, // double (non-nullable)
        'pct': pct, // double (non-nullable)
      };
    }).reversed.toList(); // Returns List<Map<String, Object>>
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
                value['day'] as String, // Cast to String
                value['amount'] as double, // Cast to double
                value['pct'] as double, // Use precomputed percentage
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // Import the pie_chart package
import '../models/transaction.dart';

class CategoryChart extends StatelessWidget {
  final List<Transaction> _recentTransactions; // Transactions for FinEXTracker
  final Map<String, double> _categoryTotals = {}; // Totals by category

  CategoryChart(this._recentTransactions, {super.key}) {
    _calculateCategoryTotals();
  }

  // Calculates total spending per category for the pie chart
  void _calculateCategoryTotals() {
    for (var transaction in _recentTransactions) {
      if (_categoryTotals.containsKey(transaction.txnCategory)) {
        _categoryTotals[transaction.txnCategory] =
            (_categoryTotals[transaction.txnCategory] ?? 0.0) +
                transaction.txnAmount;
      } else {
        _categoryTotals[transaction.txnCategory] = transaction.txnAmount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _categoryTotals.isNotEmpty
        ? Column(
            children: [
              Expanded(
                child: PieChart(
                  dataMap: _categoryTotals, // Category totals for display
                  chartRadius: MediaQuery.of(context).size.width / 2.7,
                  chartType: ChartType.disc,
                  legendOptions: LegendOptions(
                    legendPosition: LegendPosition.right,
                    showLegendsInRow: false,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Text(
              'No data to display',
              style: TextStyle(fontSize: 16),
            ),
          );
  }
}
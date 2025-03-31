import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Reports extends StatelessWidget {
  final double income; // Income tracked in FinEXTracker
  final double expenses; // Expenses tracked in FinEXTracker
  final double investments; // Investments tracked in FinEXTracker
  final double goal; // Savings goal set in FinEXTracker

  Reports(this.income, this.expenses, this.investments, this.goal, {super.key}) {
    _calculateProfitLoss();
  }

  // Calculates profit or loss (income + investments - expenses)
  double _calculateProfitLoss() {
    double profitOrLoss = income + investments - expenses;
    return profitOrLoss;
  }

  // Calculates total earnings (income + investments)
  double _calculateEarningsitLoss() {
    return income + investments;
  }

  // Determines if the savings goal is reached
  String _goalReached() {
    double profitOrLoss = _calculateProfitLoss();
    if (profitOrLoss >= goal) {
      return "Goal Reached";
    } else {
      return "Sorry! Limit your expenses";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Data map for PieChart in FinEXTracker Reports
    Map<String, double> dataMap = {
      "Income": income,
      "Expenses": expenses,
      "Investments": investments,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('FinEXTracker Reports'), // Updated from 'Reports'
        backgroundColor: Color(0xFF075E54), // WhatsApp dark green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              columnWidths: {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(3),
              },
              children: [
                _buildTableRow('Budget Goal', '\$${goal.toStringAsFixed(2)}'),
                _buildTableRow('Current Month Earnings',
                    '\$${_calculateEarningsitLoss().toStringAsFixed(2)}'),
                _buildTableRow('Current Month Expenses',
                    '\$${expenses.toStringAsFixed(2)}'),
                _buildStatusTableRow('Goal Status', _goalReached()),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: PieChart(
                dataMap: dataMap,
                chartRadius: MediaQuery.of(context).size.width / 2,
                chartType: ChartType.disc,
                legendOptions: LegendOptions(
                  showLegends: true,
                  legendPosition: LegendPosition.bottom,
                  legendTextStyle: TextStyle(
                    color: Color(0xFF075E54), // WhatsApp dark green for legend
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  chartValueStyle: TextStyle(
                    color: const Color.fromARGB(
                        255, 187, 25, 25), // Red text on chart values
                  ),
                ),
                colorList: [
                  Color(0xFF075E54), // WhatsApp dark green for Income
                  Color(0xFF25D366), // WhatsApp light green for Expenses
                  Colors.amber, // Yellow for Investments
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a standard table row for financial data
  TableRow _buildTableRow(String field, String value) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              field,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF075E54), // WhatsApp dark green for labels
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black, // Black for values
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Builds a table row for goal status with dynamic coloring
  TableRow _buildStatusTableRow(String field, String value) {
    Color statusColor = _calculateProfitLoss() >= goal
        ? Color(0xFF25D366) // WhatsApp light green for success
        : Colors.red; // Red for failure

    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              field,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF075E54), // WhatsApp dark green
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              value,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String _label; // e.g., day or category name in FinEXTracker
  final double _spendingAmount; // Amount spent in rupees
  final double _spendingPctOfTotal; // Percentage of total spending

  const ChartBar(this._label, this._spendingAmount, this._spendingPctOfTotal, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: constraints.maxHeight * 0.16,
              child: FittedBox(
                child: Text(
                  '₹${_spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // Professional black text for values
                  ),
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.04,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.6,
              width: 12, // Increased bar width for clarity
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                      color: Colors
                          .grey.shade200, // Light grey background for the bar
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: _spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(
                            0xFF25D366), // WhatsApp light green for the filled part
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.04,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.16,
              child: FittedBox(
                child: Text(
                  _label,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black, // Professional black for label text
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
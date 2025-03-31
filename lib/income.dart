import 'package:flutter/material.dart';
import 'package:js/helpers/database_helper.dart';
import './models/income_model.dart';

class Income extends StatelessWidget {
  const Income({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final IncomeModel incomeModel = IncomeModel(); // Income model for FinEXTracker
  final TextEditingController _incomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIncomeFromDatabase();
  }

  // Loads the current income from the database for FinEXTracker
  Future<void> _loadIncomeFromDatabase() async {
    try {
      double? savedIncome = await DatabaseHelper.instance.getIncome();
      if (savedIncome != null) {
        incomeModel.updateIncome(savedIncome);
        setState(() {});
      } else {
        incomeModel.initialize(0.0); // Default income if none exists
        setState(() {});
      }
    } catch (e) {
      // print('Error loading income: $e'); // Commented out to avoid print in production
    }
  }

  // Saves the new income value to the database
  void _saveIncome(BuildContext context) async {
    double newIncome = double.tryParse(_incomeController.text) ?? 0.0;
    incomeModel.updateIncome(newIncome);

    double? savedIncome = await DatabaseHelper.instance.getIncome();

    try {
      if (savedIncome != null) {
        await DatabaseHelper.instance.updateIncome(newIncome);
      } else {
        await DatabaseHelper.instance.insertIncome(newIncome);
      }

      setState(() {});
      if (!mounted) return; // Guards ScaffoldMessenger call directly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Income saved: \$${newIncome.toStringAsFixed(2)}')),
      );
    } catch (error) {
      // print('Error saving income: $error'); // Commented out to avoid print in production
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinEXTracker Income'),
        backgroundColor: Color(0xFF075E54), // WhatsApp dark green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Current Income: \$${incomeModel.income.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF075E54), // WhatsApp green
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _incomeController,
              decoration: InputDecoration(
                labelText: 'Enter New Income',
                labelStyle: TextStyle(color: Color(0xFF075E54)), // WhatsApp green
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFF25D366)), // WhatsApp light green
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF075E54), width: 2.0), // Dark green
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF25D366), // WhatsApp light green
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () => _saveIncome(context),
              child: Text(
                'Save Income',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
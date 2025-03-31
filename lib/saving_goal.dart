import 'package:flutter/material.dart';
import './helpers/database_helper.dart';

class SavingGoal extends StatelessWidget {
  const SavingGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return GoalHomePage();
  }
}

class GoalHomePage extends StatefulWidget {
  const GoalHomePage({super.key});

  @override
  GoalHomePageState createState() => GoalHomePageState();
}

class GoalHomePageState extends State<GoalHomePage> {
  final GoalModel goalModel = GoalModel(); // Goal model for FinEXTracker
  final TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGoalFromDatabase();
  }

  // Loads the current savings goal from the database
  Future<void> _loadGoalFromDatabase() async {
    try {
      double? savedGoal = await DatabaseHelper.instance.getGoal();
      if (savedGoal != null) {
        goalModel.updateGoal(savedGoal);
        setState(() {});
      } else {
        goalModel.initialize(0.0); // Default goal if none exists
        setState(() {});
      }
    } catch (e) {
      // print('Error loading goal: $e'); // Commented out to avoid print in production
    }
  }

  // Saves the new savings goal to the database
  void _saveGoal(BuildContext context) async {
    double newGoal = double.tryParse(_goalController.text) ?? 0.0;
    goalModel.updateGoal(newGoal);

    double? savedGoal = await DatabaseHelper.instance.getGoal();
    try {
      if (savedGoal != null) {
        await DatabaseHelper.instance.updateGoal(newGoal);
      } else {
        await DatabaseHelper.instance.insertGoal(newGoal);
      }

      setState(() {});
      if (!mounted) return; // Guards ScaffoldMessenger call directly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Goal saved: \$${newGoal.toStringAsFixed(2)}')),
      );
    } catch (error) {
      // print('Error saving goal: $error'); // Commented out to avoid print in production
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinEXTracker Savings Goal'),
        backgroundColor: Color(0xFF075E54), // WhatsApp dark green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Current Goal: \$${goalModel.goal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF075E54), // WhatsApp dark green
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                labelText: 'Enter New Goal',
                labelStyle: TextStyle(color: Color(0xFF075E54)), // WhatsApp dark green
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFF25D366)), // WhatsApp light green
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF075E54), width: 2.0),
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
              onPressed: () => _saveGoal(context),
              child: Text(
                'Save Goal',
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

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }
}

// Model for managing the savings goal in FinEXTracker
class GoalModel {
  double _goal = 0.0;

  void initialize(double initialGoal) {
    _goal = initialGoal;
  }

  double get goal => _goal;

  void updateGoal(double newGoal) {
    _goal = newGoal;
  }
}
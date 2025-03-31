import 'package:flutter/material.dart';
import 'expense_tracker.dart';
import 'investment_tracker.dart';
import 'income.dart';
import 'saving_goal.dart';
import 'helpers/database_helper.dart';
import 'reports.dart'; // Changed from 'Reports.dart'

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double currentGoal = 0.0; // Current savings goal in FinEXTracker
  double currentIncome = 0.0; // Total income tracked in FinEXTracker
  double totalExpense = 0.0; // Total expenses tracked in FinEXTracker
  double totalInvestment = 0.0; // Total investments tracked in FinEXTracker

  @override
  void initState() {
    super.initState();
    _loadGoal();
    _loadIncome();
    _loadExpenses();
  }

  // Loads the current savings goal from the database
  Future<void> _loadGoal() async {
    try {
      double goal = await DatabaseHelper.instance.getGoal() as double;
      setState(() {
        currentGoal = goal;
      });
    } catch (error) {
      // print('Error loading goal: $error');
    }
  }

  // Loads the total income from the database
  Future<void> _loadIncome() async {
    try {
      double income = await DatabaseHelper.instance.getIncome() as double;
      setState(() {
        currentIncome = income;
      });
    } catch (error) {
      // print('Error loading income: $error');
    }
  }

  // Loads the total expenses from the database
  Future<void> _loadExpenses() async {
    try {
      double expenseAmount = await DatabaseHelper.instance.calculateTotalExpenseAmount();
      setState(() {
        totalExpense = expenseAmount;
      });
    } catch (error) {
      // print('Error loading total expenses: $error');
    }
  }

  // Loads the total investments from the database
  Future<void> _loadInvestments() async {
    try {
      double investmentAmount = await DatabaseHelper.instance.calculateTotalInvestmentAmount();
      setState(() {
        totalInvestment = investmentAmount;
      });
    } catch (error) {
      // print('Error loading total investments: $error');
    }
  }

  // Navigates to the ExpenseTracker screen and refreshes expenses
  void _navigateToExpenseTracker(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpenseTracker()),
    );
    await _loadExpenses();
    if (!mounted) return; // Check if widget is still mounted
    // print('Total expenses are $totalExpense');
  }

  // Navigates to the InvestmentTracker screen and refreshes investments
  void _navigateToInvestmentTracker(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvestmentTracker()),
    );
    await _loadInvestments();
    if (!mounted) return; // Check if widget is still mounted
    // print('Total investments are $totalInvestment');
  }

  // Navigates to the Income screen and refreshes income
  void _navigateToIncomeTracker(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Income()),
    );
    await _loadIncome();
    if (!mounted) return; // Check if widget is still mounted
    // print('Current income is $currentIncome');
  }

  // Navigates to the SavingGoal screen and refreshes goal
  void _navigateToSavingGoal(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavingGoal()),
    );
    await _loadGoal();
    if (!mounted) return; // Check if widget is still mounted
    // print('Current goal is $currentGoal');
  }

  // Loads all data and navigates to the Reports screen
  void _getReport() async {
    await _loadGoal();
    await _loadIncome();
    await _loadInvestments();
    await _loadExpenses();
    if (!mounted) return; // Check if widget is still mounted
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Reports(currentIncome, totalExpense, totalInvestment, currentGoal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinEXTracker'), // Already updated from FinIQ
        backgroundColor: Color(0xFF075E54), // WhatsApp dark green
      ),
      backgroundColor: Colors.white, // WhatsApp-style white background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Expense Tracker Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366), // WhatsApp light green for button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _navigateToExpenseTracker(context),
                child: Text(
                  'Expense management',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),

              // Investment Tracker Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366), // WhatsApp light green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _navigateToInvestmentTracker(context),
                child: Text(
                  'Investment management',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),

              // Income Entry Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366), // WhatsApp light green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _navigateToIncomeTracker(context),
                child: Text(
                  'Income source',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),

              // Budget Goal Setting Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366), // WhatsApp light green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _navigateToSavingGoal(context),
                child: Text(
                  'Budget Goal Setting',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),

              // Reports Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366), // WhatsApp light green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _getReport(),
                child: Text(
                  'Reports',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
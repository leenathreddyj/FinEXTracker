import 'dart:io';
import 'package:flutter/material.dart';
import 'package:js/models/investment.dart';
import './widgets/new_investment_form.dart';
import './widgets/investment_list.dart';
import './helpers/database_helper.dart';

class InvestmentTracker extends StatelessWidget {
  const InvestmentTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget { // Changed from _MyHomePage to MyHomePage
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState(); // Changed from _MyHomePageState
}

class MyHomePageState extends State<MyHomePage> { // Changed from _MyHomePageState
  List<Investment> _userInvestments = []; // Investments for FinEXTracker
  bool _showChart = false;

  // _MyHomePageState constructor renamed to MyHomePageState
  MyHomePageState() {
    _updateUserInvestmentsList();
  }

  // Updates the investment list from the database
  void _updateUserInvestmentsList() {
    Future<List<Investment>> res = DatabaseHelper.instance.getAllInvestments();

    res.then((invList) {
      setState(() {
        _userInvestments = invList;
      });
    });
  }

  // Toggles chart visibility in landscape mode (currently unused)
  void _showChartHandler(bool show) {
    setState(() {
      _showChart = show;
    });
  }

  // Adds a new investment to the database
  Future<void> _addNewInvestment(
      String title, double amount, DateTime chosenDate) async {
    final newInv = Investment(
      DateTime.now().millisecondsSinceEpoch.toString(),
      title,
      amount,
      chosenDate,
    );
    int res = await DatabaseHelper.instance.insertInvestment(newInv);

    if (res != 0) {
      _updateUserInvestmentsList();
    }
  }

  // Opens the modal form to add a new investment
  void _startAddNewInvestment(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: NewInvestmentForm(_addNewInvestment),
        );
      },
    );
  }

  // Deletes an investment by ID
  Future<void> _deleteInvestment(String id) async {
    int parsedId = int.tryParse(id) ?? 0;
    int res = await DatabaseHelper.instance.deleteInvestmentById(parsedId);
    if (res != 0) {
      _updateUserInvestmentsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppBar myAppBar = AppBar(
      title: Text(
        'FinEXTracker Investments',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
      ),
      backgroundColor: Color(0xFF075E54), // WhatsApp dark green
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewInvestment(context),
          tooltip: "Add New Investment",
        ),
      ],
    );

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isLandscape =
        mediaQueryData.orientation == Orientation.landscape;

    final double availableHeight = mediaQueryData.size.height -
        myAppBar.preferredSize.height -
        mediaQueryData.padding.top -
        mediaQueryData.padding.bottom;

    final double availableWidth = mediaQueryData.size.width -
        mediaQueryData.padding.left -
        mediaQueryData.padding.right;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Show Chart",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  Switch.adaptive(
                    activeColor: Color(0xFF25D366), // WhatsApp light green
                    value: _showChart,
                    onChanged: (value) => _showChartHandler(value),
                  ),
                ],
              ),
            if (isLandscape)
              myInvestmentListContainer(
                  height: availableHeight * 0.8, width: 0.6 * availableWidth),
            if (!isLandscape)
              myInvestmentListContainer(
                  height: availableHeight * 0.7, width: availableWidth),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              backgroundColor: Color(0xFF25D366), // WhatsApp light green
              tooltip: "Add New Investment",
              onPressed: () => _startAddNewInvestment(context),
              child: Icon(Icons.add, color: Colors.white),
            ),
    );
  }

  // Container for the investment list
  Widget myInvestmentListContainer(
      {required double height, required double width}) {
    return SizedBox(
      height: height,
      width: width,
      child: InvestmentList(_userInvestments, _deleteInvestment),
    );
  }
}
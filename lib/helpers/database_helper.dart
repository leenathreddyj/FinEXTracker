import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart' as txn;
import '../models/investment.dart' as inv;

// Database table and column names for FinEXTracker
final String tableTransactions = 'transactions'; // Stores expense transactions
final String columnId = 'id'; // Unique identifier
final String columnTitle = 'title'; // Transaction or investment title
final String columnAmount = 'amount'; // Monetary value
final String columnCategory = 'category'; // Transaction category
final String columnDate = 'date'; // Date of transaction or investment

final String tableIncomes = 'incomes'; // Stores income data
final String tableGoals = 'goals'; // Stores savings goal data
final String tableInvestments = 'investments'; // Stores investment data

// Singleton class to manage the SQLite database for FinEXTracker
class DatabaseHelper {
  // Private constructor for singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // Database filename saved in the app's documents directory
  static final _databaseName = "app_database.db";
  static final _databaseVersion = 10;

  // Getter for the database instance, initializes if null
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // Initializes and opens the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Upgrades the database schema when version changes
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableInvestments (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }

  // Creates initial tables for FinEXTracker: Transactions, Incomes, Goals, Investments, Users
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTransactions (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableIncomes (
        $columnId INTEGER PRIMARY KEY,
        $columnAmount REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableGoals (
        $columnId INTEGER PRIMARY KEY,
        $columnAmount REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableInvestments (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  // Registers a new user in the users table
  Future<int> registerUser(String username, String password) async {
    Database? db = await instance.database;
    return await db!
        .insert('users', {'username': username, 'password': password});
  }

  // Verifies user credentials for login
  Future<bool> verifyUser(String username, String password) async {
    Database? db = await instance.database;
    final result = await db!.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  // Inserts a new transaction into the transactions table
  Future<int> insert(txn.Transaction element) async {
    Database? db = await database;
    int id = await db?.insert(tableTransactions, element.toMap()) ?? 0;
    return id;
  }

  // Retrieves a transaction by ID
  Future<txn.Transaction?> getTransactionById(int id) async {
    Database? db = await database;
    if (db != null) {
      List<Map<String, dynamic>> res = await db.query(
        tableTransactions,
        columns: [
          columnId,
          columnTitle,
          columnAmount,
          columnCategory,
          columnDate
        ],
        where: '$columnId = ?',
        whereArgs: [id],
      );

      if (res.isNotEmpty) {
        return txn.Transaction.fromMap(res.first);
      }
    }
    return null;
  }

  // Retrieves all transactions from the transactions table
  Future<List<txn.Transaction>> getAllTransactions() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = [];

    if (db != null) {
      res = await db.query(tableTransactions, columns: [
        columnId,
        columnTitle,
        columnAmount,
        columnCategory,
        columnDate
      ]);
    }

    List<txn.Transaction> list =
        res.map((e) => txn.Transaction.fromMap(e)).toList();
    return list;
  }

  // Calculates the total amount of all transactions
  Future<double> calculateTotalExpenseAmount() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = [];

    if (db != null) {
      res = await db.query(tableTransactions, columns: [
        columnId,
        columnTitle,
        columnAmount,
        columnCategory,
        columnDate
      ]);
    }

    List<txn.Transaction> list =
        res.map((e) => txn.Transaction.fromMap(e)).toList();
    double sum = list.fold(
        0, (previousValue, transaction) => previousValue + transaction.txnAmount);
    return sum;
  }

  // Deletes a transaction by ID
  Future<int> deleteTransactionById(int id) async {
    Database? db = await database;
    if (db != null) {
      int res = await db.delete(
        tableTransactions,
        where: "id = ?",
        whereArgs: [id],
      );
      return res;
    } else {
      return 0;
    }
  }

  // Deletes all transactions
  Future<int> deleteAllTransactions() async {
    Database? db = await database;
    if (db != null) {
      int res = await db.delete(tableTransactions, where: '1');
      return res;
    } else {
      return 0;
    }
  }

  // Inserts a new income value into the incomes table
  Future<int> insertIncome(double amount) async {
    final db = await database;
    return await db!.insert(tableIncomes, {columnAmount: amount});
  }

  // Retrieves the current income value
  Future<double?> getIncome() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db!.query(tableIncomes);
    if (result.isNotEmpty) {
      return result.first[columnAmount] as double;
    } else {
      return null;
    }
  }

  // Updates the income value
  Future<void> updateIncome(double amount) async {
    final db = await database;
    await db!.update(tableIncomes, {columnAmount: amount});
  }

  // Inserts a new savings goal into the goals table
  Future<int> insertGoal(double amount) async {
    final db = await database;
    return await db!.insert(tableGoals, {columnAmount: amount});
  }

  // Retrieves the current savings goal
  Future<double?> getGoal() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db!.query(tableGoals);
    if (result.isNotEmpty) {
      return result.first[columnAmount] as double;
    } else {
      return null;
    }
  }

  // Updates the savings goal
  Future<void> updateGoal(double amount) async {
    final db = await database;
    await db!.update(tableGoals, {columnAmount: amount});
  }

  // Inserts a new investment into the investments table
  Future<int> insertInvestment(inv.Investment element) async {
    Database? db = await database;
    int id = await db?.insert(tableInvestments, element.toMap()) ?? 0;
    return id;
  }

  // Retrieves an investment by ID
  Future<inv.Investment?> getInvestmentById(int id) async {
    Database? db = await database;
    if (db != null) {
      List<Map<String, dynamic>> res = await db.query(
        tableInvestments,
        columns: [columnId, columnTitle, columnAmount, columnDate],
        where: '$columnId = ?',
        whereArgs: [id],
      );

      if (res.isNotEmpty) {
        return inv.Investment.fromMap(res.first);
      }
    }
    return null;
  }

  // Retrieves all investments from the investments table
  Future<List<inv.Investment>> getAllInvestments() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = [];

    if (db != null) {
      res = await db.query(tableInvestments,
          columns: [columnId, columnTitle, columnAmount, columnDate]);
    }

    List<inv.Investment> list =
        res.map((e) => inv.Investment.fromMap(e)).toList();
    return list;
  }

  // Calculates the total amount of all investments
  Future<double> calculateTotalInvestmentAmount() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = [];

    if (db != null) {
      res = await db.query(tableInvestments,
          columns: [columnId, columnTitle, columnAmount, columnDate]);
    }

    List<inv.Investment> list =
        res.map((e) => inv.Investment.fromMap(e)).toList();
    double sum = list.fold(
        0, (previousValue, investment) => previousValue + investment.invAmount);
    return sum;
  }

  // Deletes an investment by ID
  Future<int> deleteInvestmentById(int id) async {
    Database? db = await database;
    if (db != null) {
      int res = await db.delete(
        tableInvestments,
        where: "id = ?",
        whereArgs: [id],
      );
      return res;
    } else {
      return 0;
    }
  }

  // Deletes all investments
  Future<int> deleteAllInvestments() async {
    Database? db = await database;
    if (db != null) {
      int res = await db.delete(tableInvestments, where: '1');
      return res;
    } else {
      return 0;
    }
  }
}
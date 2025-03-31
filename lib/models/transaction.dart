// Model for representing a transaction in FinEXTracker
class Transaction {
  final String _id; // Unique identifier for the transaction
  final String _title; // Title or name of the transaction
  final double _amount; // Transaction amount in FinEXTracker
  final String _category; // Category of the transaction (e.g., Food, Housing)
  final DateTime _date; // Date and time of the transaction

  // Public getters for accessing transaction properties
  String get txnId => _id;
  String get txnTitle => _title;
  double get txnAmount => _amount;
  String get txnCategory => _category;
  DateTime get txnDateTime => _date;

  // Constructor with initialization of all fields
  Transaction(
    this._id,
    this._title,
    this._amount, // Transaction amount passed during creation
    this._category,
    this._date,
  );

  // Creates a Transaction object from a database map
  Transaction.fromMap(Map<String, dynamic> map)
      : _id = map['id'].toString(),
        _title = map['title'],
        _amount = map['amount'] ?? 0.0, // Default to 0.0 if amount is null
        _category = map['category'],
        _date = DateTime.parse(map['date']);

  // Converts this Transaction object to a map for database storage
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': int.tryParse(_id), // Parse ID as integer if possible
      'title': _title,
      'amount': _amount,
      'category': _category,
      'date': _date.toIso8601String(), // Store date in ISO format
    };
    return map;
  }
}
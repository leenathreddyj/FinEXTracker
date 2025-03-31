// Model for representing an investment in FinEXTracker
class Investment {
  final String _id; // Unique identifier for the investment
  final String _title; // Title or name of the investment
  final double _amount; // Investment amount in FinEXTracker
  final DateTime _date; // Date and time of the investment

  // Public getters for accessing investment properties
  String get invId => _id;
  String get invTitle => _title;
  double get invAmount => _amount;
  DateTime get invDateTime => _date;

  // Constructor with initialization of all fields
  Investment(
    this._id,
    this._title,
    this._amount, // Investment amount passed during creation
    this._date,
  );

  // Creates an Investment object from a database map
  Investment.fromMap(Map<String, dynamic> map)
      : _id = map['id'].toString(),
        _title = map['title'],
        _amount = map['amount'] ?? 0.0, // Default to 0.0 if amount is null
        _date = DateTime.parse(map['date']);

  // Converts this Investment object to a map for database storage
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': int.tryParse(_id), // Parse ID as integer if possible
      'title': _title,
      'amount': _amount,
      'date': _date.toIso8601String(), // Store date in ISO format
    };
    return map;
  }
}
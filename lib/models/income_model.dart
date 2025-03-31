// Model for managing income in FinEXTracker
class IncomeModel {
  double _income = 0.0; // Private income value tracked in FinEXTracker

  // Sets the initial income value
  void initialize(double initialIncome) {
    _income = initialIncome;
  }

  // Getter for the current income
  double get income => _income;

  // Updates the income with a new value
  void updateIncome(double newIncome) {
    _income = newIncome;
  }

/*
  // Commented-out Singleton pattern implementation (not currently in use)
  // Singleton pattern: Private constructor and instance
  static final IncomeModel _instance = IncomeModel._internal();

  factory IncomeModel() {
    return _instance;
  }

  IncomeModel._internal();

  // Initialize income if not already initialized
  Future<void> initialize(double initialIncome) async {
    if (!_initialized) {
      _income = initialIncome;
      _initialized = true;
    }
  }

  // Getter for current income
  double get income => _income;

  // Update income
  void updateIncome(double newIncome) {
    _income = newIncome;
  }
*/
}
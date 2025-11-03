import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class ExpenseDatabase {
  static const String _boxName = 'expenses';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
    await Hive.openBox<Expense>(_boxName);
  }

  Box<Expense> get _box => Hive.box<Expense>(_boxName);

  // Add expense
  Future<void> addExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  // Get all expenses
  List<Expense> getAllExpenses() {
    return _box.values.toList();
  }

  // Get expenses by date range
  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _box.values.where((expense) {
      return expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
          expense.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get expenses by category
  List<Expense> getExpensesByCategory(String category) {
    return _box.values
        .where((expense) => expense.category == category)
        .toList();
  }

  // Update expense
  Future<void> updateExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  // Get total expenses
  double getTotalExpenses() {
    return _box.values.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get total by category
  Map<String, double> getTotalByCategory() {
    final Map<String, double> categoryTotals = {};
    for (var expense in _box.values) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  // Get expenses for current month
  List<Expense> getCurrentMonthExpenses() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return getExpensesByDateRange(firstDay, lastDay);
  }

  // Listen to changes
  Stream<BoxEvent> watchExpenses() {
    return _box.watch();
  }
}

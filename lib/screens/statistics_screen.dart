import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/expense_database.dart';
import '../constants/categories.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final ExpenseDatabase _database = ExpenseDatabase();
  bool _showAllTime = false;

  List<Expense> get _expenses {
    return _showAllTime
        ? _database.getAllExpenses()
        : _database.getCurrentMonthExpenses();
  }

  Map<String, double> get _categoryTotals {
    final Map<String, double> totals = {};
    for (var expense in _expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  Map<String, double> get _dailyTotals {
    final Map<String, double> totals = {};
    for (var expense in _expenses) {
      final dateKey = DateFormat('MM/dd').format(expense.date);
      totals[dateKey] = (totals[dateKey] ?? 0) + expense.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final totalExpenses = _expenses.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showAllTime ? Icons.date_range : Icons.all_inclusive),
            onPressed: () {
              setState(() {
                _showAllTime = !_showAllTime;
              });
            },
            tooltip: _showAllTime ? 'Show Current Month' : 'Show All Time',
          ),
        ],
      ),
      body: _expenses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No data to display',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _showAllTime ? 'All Time Total' : 'This Month',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${totalExpenses.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_expenses.length} transactions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pie Chart - Category Distribution
                  const Text(
                    'Expenses by Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 300,
                        child: _categoryTotals.isEmpty
                            ? const Center(child: Text('No data'))
                            : PieChart(
                                PieChartData(
                                  sections: _categoryTotals.entries.map((
                                    entry,
                                  ) {
                                    final percentage =
                                        (entry.value / totalExpenses * 100);
                                    return PieChartSectionData(
                                      value: entry.value,
                                      title:
                                          '${percentage.toStringAsFixed(1)}%',
                                      color: ExpenseCategories.getColor(
                                        entry.key,
                                      ),
                                      radius: 100,
                                      titleStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }).toList(),
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Legend
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: _categoryTotals.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ExpenseCategories.getColor(
                            entry.key,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              ExpenseCategories.getIcon(entry.key),
                              size: 16,
                              color: ExpenseCategories.getColor(entry.key),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Bar Chart - Daily Expenses
                  if (!_showAllTime) ...[
                    const Text(
                      'Daily Expenses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(height: 300, child: _buildBarChart()),
                      ),
                    ),
                  ],

                  // Category Breakdown List
                  const SizedBox(height: 24),
                  const Text(
                    'Category Breakdown',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ..._categoryTotals.entries.map((entry) {
                    final percentage = (entry.value / totalExpenses * 100);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ExpenseCategories.getColor(
                            entry.key,
                          ).withOpacity(0.2),
                          child: Icon(
                            ExpenseCategories.getIcon(entry.key),
                            color: ExpenseCategories.getColor(entry.key),
                          ),
                        ),
                        title: Text(entry.key),
                        subtitle: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ExpenseCategories.getColor(entry.key),
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${entry.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildBarChart() {
    if (_dailyTotals.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final sortedEntries = _dailyTotals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY:
            sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b) *
            1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '\$${rod.toY.toStringAsFixed(2)}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedEntries.length) {
                  return const Text('');
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    sortedEntries[value.toInt()].key,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
        ),
        borderData: FlBorderData(show: false),
        barGroups: sortedEntries.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value,
                color: Theme.of(context).colorScheme.primary,
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

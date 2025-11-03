import 'package:flutter/material.dart';

class ExpenseCategories {
  static const Map<String, IconData> categories = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Shopping': Icons.shopping_bag,
    'Entertainment': Icons.movie,
    'Bills': Icons.receipt,
    'Health': Icons.health_and_safety,
    'Education': Icons.school,
    'Other': Icons.more_horiz,
  };

  static const Map<String, Color> categoryColors = {
    'Food': Colors.orange,
    'Transport': Colors.blue,
    'Shopping': Colors.purple,
    'Entertainment': Colors.pink,
    'Bills': Colors.red,
    'Health': Colors.green,
    'Education': Colors.teal,
    'Other': Colors.grey,
  };

  static List<String> get categoryList => categories.keys.toList();

  static IconData getIcon(String category) {
    return categories[category] ?? Icons.category;
  }

  static Color getColor(String category) {
    return categoryColors[category] ?? Colors.grey;
  }
}

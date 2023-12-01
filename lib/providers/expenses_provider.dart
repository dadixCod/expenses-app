import 'package:expense/models/category.dart';
import 'package:expense/models/dates_filter.dart';
import 'package:expense/models/expense.dart';
import 'package:expense/providers/dates_filter_provider.dart';

import 'package:expense/services/sqlite_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Expenses with ChangeNotifier {
  //Original List
  List<Expense> _originalExpenses = [];
  //Filtered LIST
  List<Expense> _filteredExpenses = [];

  List<Expense> get expenses => _filteredExpenses;

  double get filteredAmount {
    double total = 0.0;
    for (var expense in _filteredExpenses) {
      total += expense.amount;
    }
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    for (var expense in _originalExpenses) {
      total += expense.amount;
    }
    return total;
  }

  void clearExpenses() {
    _originalExpenses.clear();
    _filteredExpenses.clear();
    notifyListeners();
  }

  Future<void> addExpense(double amount, Category category, String description, DateTime date, BuildContext context) async {
    final newExpense = Expense(
      id: const Uuid().v4(),
      amount: amount,
      category: category,
      description: description,
      date: date,
    );
    _originalExpenses.add(newExpense);
    // ignore: use_build_context_synchronously
    _applyFilter(context);
    SqliteService.insert('Expenses', {
      'id': newExpense.id,
      'amount': newExpense.amount,
      'categoryName': newExpense.category.name,
      'description': newExpense.description,
      'date': newExpense.date.toIso8601String(),
    });

    notifyListeners();
  }

  Future<void> fetchExpenses() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final datalist = await SqliteService.getData('Expenses');
      if (datalist.isEmpty) {
        await SqliteService.initDb(userId);
        _originalExpenses = [];
      }
      _originalExpenses = datalist.map((expenseData) {
        //fetching category name
        String categoryName = expenseData['categoryName'];

        // corresponding category by name
        Category category = Categories().categories.firstWhere((cat) => cat.name == categoryName);

        // date checker
        DateTime date = expenseData['date'] != null ? DateTime.parse(expenseData['date'].toString()) : DateTime.now();
        // Create Expense object
        return Expense(
          id: expenseData['id'],
          amount: double.parse(expenseData['amount'].toString()),
          category: category,
          description: expenseData['description'].toString(),
          date: date,
        );
      }).toList();
      // notifyListeners();
    } catch (error) {
      print('Error in fetchExpenses: $error');
    }
  }

  Future<void> deleteExpense(Expense selectedExpense) async {
    _originalExpenses.removeWhere((expense) => expense == selectedExpense);
    _filteredExpenses.removeWhere((expense) => expense == selectedExpense);
    await SqliteService.deleteExpense(selectedExpense);
    notifyListeners();
  }

  void fetchExpensesByFilter(DateFilter? selectedFilter) {
    _filteredExpenses = _originalExpenses.where((expense) {
      if (selectedFilter != null) {
        if (selectedFilter.name == 'Today') {
          return DateTime.now().difference(expense.date).inDays == 0;
        } else if (selectedFilter.name == 'This week') {
          return DateTime.now().difference(expense.date).inDays <= 7;
        } else if (selectedFilter.name == 'This Month') {
          return expense.date.month == DateTime.now().month && expense.date.year == DateTime.now().year;
        } else if (selectedFilter.name == 'All time') {
          return true;
        }
      }
      return true;
    }).toList();
    notifyListeners();
  }

  Future<void> _applyFilter(BuildContext context) async {
    fetchExpensesByFilter(Provider.of<DatesFilter>(context, listen: false).selectedFilter);
  }
}

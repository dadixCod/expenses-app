import 'package:expense/components/expense_item.dart';
import 'package:expense/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key});

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<Expenses>(context);

    return FutureBuilder<void>(
      future: expensesProvider.fetchExpenses(), // Use fetchExpenses as the future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //show a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If the Future throws an error,
          return Text('Error: ${snapshot.error}');
        } else {
          return SizedBox(
            height: 300,
            child: expensesProvider.expenses.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                          child: Image.asset(
                            'assets/images/empty.png',
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "You haven't added any expenses yet",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5);
                    },
                    itemCount: expensesProvider.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expensesProvider.expenses[index];
                      return ExpenseItem(expense: expense);
                    },
                  ),
          );
        }
      },
    );
  }
}

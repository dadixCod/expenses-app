import 'package:expense/models/expense.dart';
import 'package:expense/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  const ExpenseItem({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Expense?"),
                  content: const Text("Confirm that you want to delete this expense"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () {
                          Provider.of<Expenses>(context, listen: false).deleteExpense(expense);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                ),
              );
            },
            autoClose: true,
            borderRadius: BorderRadius.circular(10),
            label: 'Delete',
            icon: Icons.delete,
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          )
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        elevation: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    width: 2,
                    color: Colors.black.withOpacity(0.15),
                  ),
                ),
                child: Icon(
                  expense.category.icon,
                  size: 35,
                ),
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      DateFormat.Hm().format(expense.date),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Text(
                "\$${expense.amount}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

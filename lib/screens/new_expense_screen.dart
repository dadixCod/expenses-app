import 'package:expense/models/category.dart';
import 'package:expense/providers/expenses_provider.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../components/components.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class NewExpense extends StatefulWidget {
  static const routeName = '/new_expense';

  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  //Text Field Controllers
  TextEditingController amountController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  Category selectedCategory = Categories().categories.first;

  DateTime selectedDate = DateTime.now();

  addExpense() async {
    final expenses = Provider.of<Expenses>(context, listen: false);
    if (amountController.text == '' || descriptionController.text == '') {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: 'Please try to fill all the fields',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    await expenses.addExpense(
      double.tryParse(amountController.text)!,
      selectedCategory,
      descriptionController.text,
      selectedDate,
      context,
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey[100],
                    ),
                    child: const Icon(
                      Icons.clear_rounded,
                      size: 30,
                    ),
                  ),
                ),
                const Gap(25),
                const Text(
                  "Add new expense",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(10),
                Text(
                  "Enter the details of your expense to help you track your spending",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(20),
                ExpenseTextField(
                  textInputType: TextInputType.number,
                  label: 'Enter Amount',
                  hint: '550.00',
                  prefixText: '\$',
                  controller: amountController,
                ),
                const Gap(20),
                ExpenseTextField(
                  label: 'Description',
                  hint: 'Suya and Garri',
                  controller: descriptionController,
                ),
                const Gap(20),
                CategorySelector(
                  onCategorySelected: (category) {
                    selectedCategory = category;
                  },
                ),
                const Gap(20),
                DateSelector(
                  onDateSelected: (date) {
                    selectedDate = date;
                  },
                ),
                const Gap(20),
                AddExpenseButton(
                  onTap: addExpense,
                  text: 'Add expense',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

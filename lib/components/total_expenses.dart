import 'package:expense/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalExpenses extends StatelessWidget {
  const TotalExpenses({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Expenses>(
      builder: (context, expenses, child) => Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              tileMode: TileMode.repeated,
              colors: [
                Colors.black,
                Colors.grey[800]!,
              ],
              stops: [
                0.0,
                1.0,
              ],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Spend so far",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 18,
                ),
              ),
              Text(
                "\$ ${expenses.filteredAmount}",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          )),
    );
  }
}

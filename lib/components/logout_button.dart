import 'package:expense/providers/expenses_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({super.key});

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

Future<bool> clearPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}

class _LogOutButtonState extends State<LogOutButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          Provider.of<Expenses>(context, listen: false).clearExpenses();
          await clearPrefs();
          await FirebaseAuth.instance.signOut();
          setState(() {
            isLoading = false;
          });
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              color: Colors.red,
            ),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Text(
                    "Log out",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
          ),
        ));
  }
}

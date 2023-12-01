import 'package:expense/screens/home_screen.dart';
import 'package:expense/screens/new_expense_screen.dart';
import 'package:expense/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedIndex = 0;
  
  static List<Widget> get _widgetOptions => [
    const HomeScreen(),
    const ProfileScreen(),
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.black87,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: selectedIndex == 0
            ? FloatingActionButton(
                isExtended: true,
                backgroundColor: Colors.black87,
                onPressed: () {
                  Navigator.of(context).pushNamed(NewExpense.routeName);
                },
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(Icons.add),
                ),
              )
            : null,
      ),
    );
  }
}

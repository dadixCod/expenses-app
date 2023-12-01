import 'dart:convert';

// import 'package:expense/providers/expenses_provider.dart';
import 'package:expense/providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/components.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home_screen';

  const HomeScreen({super.key});

  Future<Map<String, dynamic>> fetchImageUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userInfosString = prefs.getString('user_infos');
    if (userInfosString == null || userInfosString.isEmpty) {
      final userData = await Profile.getUserData(userId);
      final String username = userData['username'] ?? '';
      final String imageUrl = userData['image_url'] ?? '';
      final String email = userData['email'] ?? '';
      prefs.setString(
          'user_infos',
          jsonEncode({
            'username': username,
            'image_url': imageUrl,
            'email': email,
          }));
      return {'username': username, 'image_url': imageUrl, 'email': email};
    }
    final Map<String, dynamic> userInfos = await jsonDecode(userInfosString);
    return userInfos;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileRow(
                            future: fetchImageUsername(),
                          ),
                          const Gap(10),
                          // TextButton(
                          //     onPressed: () {
                          //       SqliteService.clearDatabase();
                          //     },
                          //     child: Text("Clear db")),
                          const DatesFilterList(),
                          const Gap(20),
                          const TotalExpenses(),
                          const Gap(15),
                          const FilterDatesText(),
                          const Gap(10),
                          const ExpensesList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

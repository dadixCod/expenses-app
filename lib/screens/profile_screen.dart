import 'dart:convert';
import 'package:flutter/material.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import '../components/components.dart';
import '../providers/providers.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = 'profile';

  const ProfileScreen({super.key});
  Future<Map<String, dynamic>> fetchData() async {
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
    final String email = userInfos['email'] ?? '';
    return {'username': userInfos['username'], 'image_url': userInfos['image_url'], 'email': email};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Hero(
                            tag: 'avatar',
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(snapshot.data?['image_url']),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data?['username'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                    Card(
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "email:  ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data?['email'],
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Gap(20),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Expenses:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Consumer<Expenses>(
                              builder: (context, expenses, child) => Text(
                                "\$${expenses.totalAmount.toString()}",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LogOutButton(),
                      ],
                    ))
                  ],
                );
              } else {
                return const Center(
                  child: Text("Data fetching went wrong"),
                );
              }
            }),
      ),
    );
  }
}

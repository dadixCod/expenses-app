// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileRow extends StatelessWidget {
  final Future<Map<String, dynamic>> future;

  const ProfileRow({
    super.key,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final String username = snapshot.data?['username'] ?? '';
            final String imageUrl = snapshot.data?['image_url'] ?? '';
            return Row(
              children: [
                Hero(
                  tag: 'avatar',
                  transitionOnUserGestures: true,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(ProfileScreen.routeName);
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                ),
                const Gap(15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Text(
                        "Good morning,$username ",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Track your expenses, start your day right",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withAlpha(150),
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return Center(
              child: Text("Error getting user Credentials"),
            );
          }
        });
  }
}

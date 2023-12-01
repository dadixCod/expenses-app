import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  static Future<Map<String, dynamic>> getUserData(String userId) async {
    final data = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (data.exists) {
      Map<String, dynamic> userData = data.data()!;
      return userData;
    } else {
      return {};
    }
  }
}

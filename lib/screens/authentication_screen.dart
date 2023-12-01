import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/components.dart';
import '../providers/providers.dart';


class AuthenticationScreen extends StatefulWidget {
  static const routeName = './authentication';
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    _mounted = true;
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
  ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      await Provider.of<Expenses>(context, listen: false).fetchExpenses();

      final ref = FirebaseStorage.instance.ref().child('user_image').child('${userCredential.user!.uid}.jpg');
      await ref.putFile(image);
      final url = await ref.getDownloadURL();

      //Storing locally username ,email , image_url
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'user_infos',
          jsonEncode({
            'username': username,
            'email': email,
            'image_url': url,
          }));

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        'image_url': url,
      });

      setState(() {
        _isLoading = false;
      });
    } on FirebaseException catch (error) {
      var message = 'An error occured , Please check your credentials';
      if (error.message != null) {
        message = error.message!;
      }
      if (_mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          // ignore: use_build_context_synchronously
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      submitAuthForm: _submitAuthForm,
      isLoading: _isLoading,
    );
  }
}

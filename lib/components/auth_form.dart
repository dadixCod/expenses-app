import 'dart:io';

import 'package:expense/components/my_button.dart';
import 'package:expense/components/user_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.submitAuthForm, required this.isLoading});
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File imageFile,
    bool isLogin,
  ) submitAuthForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool obscure = true;
  final _formKey = GlobalKey<FormState>();
  var isLogin = false;
  File? userImageFile;
  //Text Field Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  void _pickedImage(File image) {
    userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (userImageFile == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please take an image'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }
    if (isValid!) {
      _formKey.currentState!.save();
      widget.submitAuthForm(
        emailController.text.trim(),
        passwordController.text.trim(),
        usernameController.text.trim(),
        userImageFile ?? File(''),
        isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 180,
                          child: Image.asset("assets/images/expense.png"),
                        ),
                      ],
                    ),
                    const Text(
                      "EXPENSE IT",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Gap(10),
                    if (!isLogin) UserImage(_pickedImage),
                    if (!isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        keyboardType: TextInputType.emailAddress,
                        controller: usernameController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return 'Please enter more than 5 caracters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                      ),
                    const Gap(20),
                    TextFormField(
                      key: const ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@gmail.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    const Gap(20),
                    TextFormField(
                      key: const ValueKey('password'),
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Please longer password';
                        }
                        return null;
                      },
                      obscureText: obscure,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 5),
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            child: Container(
                              child: obscure ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                            ),
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    const Gap(30),
                    MyButton(
                      onTap: _trySubmit,
                      text: isLogin ? 'Login' : 'Sign up',
                      isLoading: widget.isLoading,
                    ),
                    const Gap(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin ? "Dosn't have account? " : "Already have account? ",
                          style: const TextStyle(fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin ? 'Sign up' : 'Login',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

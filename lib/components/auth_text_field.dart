import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? prefixText;
  bool obscure;
  AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.obscure = false,
    this.prefixText,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const Gap(5),
        TextField(
          keyboardType: widget.textInputType,
          controller: widget.controller,
          obscureText: widget.obscure,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(18),
            prefixText: widget.prefixText,
            suffix: widget.label == 'Password'
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.obscure = !widget.obscure;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      padding: EdgeInsets.only(bottom: 0, top: 0),
                      height: 20,
                      width: 20,
                      child: widget.obscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    ),
                  )
                : null,
            hintText: widget.hint,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 2,
              ),
            ),
          ),
        )
      ],
    );
  }
}

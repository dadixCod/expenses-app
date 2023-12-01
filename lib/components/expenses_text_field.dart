import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class ExpenseTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? prefixText;
  
  const ExpenseTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.textInputType = TextInputType.text,

    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const Gap(5),
        TextField(
          keyboardType: textInputType,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(18),
            prefixText: prefixText,
            
            hintText: hint,
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

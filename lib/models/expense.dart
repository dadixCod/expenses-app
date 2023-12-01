// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:expense/models/category.dart';
import 'package:uuid/uuid.dart';

class Expense {
  final String id;
  final double amount;
  final Category category;
  final String description;
  final DateTime date;
  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  Expense copyWith({
    String? id,
    double? amount,
    Category? category,
    String? description,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'Expense(amount: $amount, category: $category, description: $description, date: $date)';
  }

  @override
  bool operator ==(covariant Expense other) {
    if (identical(this, other)) return true;

    return other.id == id && other.amount == amount && other.category == category && other.description == description && other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^ amount.hashCode ^ category.hashCode ^ description.hashCode ^ date.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id':id,
      'amount': amount,
      'category': category.toMap(),
      'description': description,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    try {
      final amount = map['amount'] as double;
      final category = Category.fromMap(map['category'] as Map<String, dynamic>);
      final description = map['description'] as String;
      final date = map['date'].toString();

      return Expense(
        id: const Uuid().v4(),
        amount: amount,
        category: category,
        description: description,
        date: DateTime.parse(date),
      );
    } catch (e) {
      print("Error parsing date: $e");
      return Expense(
        id: 'uknown',
        amount: 0.0,
        category: Categories().categories.first, // Provide a default category
        description: 'Invalid Expense',
        date: DateTime.now(),
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source) as Map<String, dynamic>);
}

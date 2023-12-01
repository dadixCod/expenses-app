// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  Category({
    required this.name,
    required this.icon,
  });
  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.icon == icon;
  }

  @override
  int get hashCode => name.hashCode ^ icon.hashCode;

  Category copyWith({
    String? name,
    IconData? icon,
  }) {
    return Category(
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'icon': icon.codePoint,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Category(name: $name, icon: $icon)';
}

class Categories {
  final List<Category> categories = [
    Category(
      name: 'Food',
      icon: Icons.food_bank,
    ),
    Category(
      name: 'Shopping',
      icon: Icons.shopping_bag,
    ),
    Category(
      name: 'Transport',
      icon: Icons.travel_explore,
    ),
  ];
}

import 'package:expense/models/category.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategorySelector extends StatefulWidget {
  final Function(Category) onCategorySelected;
  const CategorySelector({super.key, required this.onCategorySelected});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late Category selectedCategory; // Initialize with a default category

  @override
  void initState() {
    super.initState();
    selectedCategory = Categories().categories.first; // Set the default category
  }

  @override
  Widget build(BuildContext context) {
    final categories = Categories().categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const Gap(15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButton(
            underline: Container(),
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
            ),
            borderRadius: BorderRadius.circular(20),
            isExpanded: true,
            value: selectedCategory,
            items: categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(category.icon),
                        const SizedBox(width: 8),
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (newSelectedCategory) {
              setState(() {
                selectedCategory = newSelectedCategory!;
                widget.onCategorySelected(newSelectedCategory);
              });
            },
          ),
        ),
      ],
    );
  }
}

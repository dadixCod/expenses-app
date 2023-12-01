import 'package:expense/providers/dates_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterDatesText extends StatelessWidget {
  const FilterDatesText({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatesFilter>(builder: (context, datesFilter, child) {
      String text = '';
      final selectedFilter = datesFilter.dates.firstWhere((filter) => filter.isSelected);
      switch (selectedFilter.name) {
        case 'Today':
          text = 'Today,${DateFormat.MMMd().format(DateTime.now())}';
        case 'This week':
          text = 'This week';
        case 'This Month':
          text = 'This Month, ${DateFormat.MMMM().format(DateTime.now())}';
      }
      return Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black.withOpacity(0.6),
        ),
      );
    });
  }
}

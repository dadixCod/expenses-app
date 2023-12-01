import 'package:expense/models/dates_filter.dart';
import 'package:expense/providers/dates_filter_provider.dart';
import 'package:expense/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DateFilterItem extends StatefulWidget {
  final DateFilter filter;

  const DateFilterItem({super.key, required this.filter});

  @override
  State<DateFilterItem> createState() => _DateFilterItemState();
}

class _DateFilterItemState extends State<DateFilterItem> {
  Color bgColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final datesFilter = Provider.of<DatesFilter>(context, listen: false);
        datesFilter.selectFilter(widget.filter);
        datesFilter.selectedFilter = widget.filter;
        Provider.of<Expenses>(context, listen: false).fetchExpensesByFilter(widget.filter);
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 15, top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: widget.filter.isSelected ? Colors.black : bgColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: Colors.black.withOpacity(0.3),
            )),
        child: Text(
          widget.filter.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: widget.filter.isSelected ? Colors.white : Colors.black.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:expense/components/date_filter_item.dart';
import 'package:expense/providers/dates_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatesFilterList extends StatelessWidget {
  const DatesFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    // final datesFilter = Provider.of<DatesFilter>(context);

    return Consumer<DatesFilter>(builder: (context, datesFilter, child) {
      final datesList = datesFilter.dates;
      return SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: datesList.length,
          itemBuilder: (context, index) {
            final filter = datesList[index];
            return DateFilterItem(filter: filter);
          },
        ),
      );
    });
  }
}

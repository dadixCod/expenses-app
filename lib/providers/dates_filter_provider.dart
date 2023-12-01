import 'package:expense/models/dates_filter.dart';
import 'package:flutter/material.dart';

class DatesFilter with ChangeNotifier {
  // Default value is today: this is to fetch the default today filter selected by the app
  DateFilter? _selectedFilter = DateFilter(name: 'Today');
  final List<DateFilter> _dates = [
    DateFilter(name: 'Today', isSelected: true),
    DateFilter(name: 'This week'),
    DateFilter(name: 'This Month'),
    DateFilter(name: 'All time'),
  ];

  List<DateFilter> get dates => _dates;
  DateFilter? get selectedFilter => _selectedFilter;
  set selectedFilter(DateFilter? filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void selectFilter(DateFilter selectedFilter) {
    for (var filter in _dates) {
      filter.isSelected = (filter == selectedFilter);
    }
    notifyListeners();
  }
}

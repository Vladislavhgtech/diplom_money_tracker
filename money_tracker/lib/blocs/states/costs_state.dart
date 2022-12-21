import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../models/category.dart';
import '../../models/cost.dart';

@immutable
class CostsState extends Equatable {
  final DateTime date;
  final List<Category> categories;
  final List<Cost> costs;
  final bool isLoading;

  const CostsState(
      {required this.date,
      required this.categories,
      required this.costs,
      required this.isLoading});

  @override
  List<Object> get props => [date, categories, costs, isLoading];
}

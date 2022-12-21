import 'package:equatable/equatable.dart';

import '../../models/category.dart';
import '../../models/cost.dart';

abstract class CostsEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SetDateRequested extends CostsEvent {
  final DateTime date;

  SetDateRequested(this.date);
}

class UpdateDataRequested extends CostsEvent {
  UpdateDataRequested();
}

class AddCategoryRequested extends CostsEvent {
  final String name;
  final String color;

  AddCategoryRequested(this.name, this.color);
}

class AddCostRequested extends CostsEvent {
  final double sum;
  final DateTime date;
  final Category category;

  AddCostRequested(this.sum, this.date, this.category);
}

class FlagIsDeleteCategoryRequested extends CostsEvent {
  final Category category;

  FlagIsDeleteCategoryRequested(this.category);
}

class FlagIsDeleteCostRequested extends CostsEvent {
  final Cost cost;

  FlagIsDeleteCostRequested(this.cost);
}

class DeleteCategoryRequested extends CostsEvent {
  final Category category;

  DeleteCategoryRequested(this.category);
}

class DeleteCostRequested extends CostsEvent {
  final Cost cost;

  DeleteCostRequested(this.cost);
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'cost.dart';

class Category extends Equatable {
  Category(this.id, this.reference, this.name, this.color, this.isDelete);

  final String id;
  final DocumentReference reference;
  final String name;
  final String color;
  final bool isDelete;

  @override
  List<Object> get props => [id, reference, name, color, isDelete];
}

Category? findElement(List<Category> list, String id) {
  for (var item in list) {
    if (item.id == id) {
      return item;
    }
  }
  return null;
}

List<Cost> loadCostsOneCategory(List<Cost> allCosts, Category category) {
  List<Cost> list = [];
  for (var item in allCosts) {
    if (item.category.id == category.id) {
      list.add(item);
    }
  }
  return list;
}
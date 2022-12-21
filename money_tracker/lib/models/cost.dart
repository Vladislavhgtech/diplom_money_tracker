import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'category.dart';

class Cost extends Equatable {
  Cost(this.id, this.category, this.reference, this.date, this.sum, this.isDelete);

  final String id;
  final Category category;
  final DocumentReference reference;
  final DateTime date;
  final double sum;
  final bool isDelete;

  @override
  List<Object> get props => [id, category, reference, date, sum, isDelete];

}
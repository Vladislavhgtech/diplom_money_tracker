import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

import '../models/category.dart';
import '../models/cost.dart';
import '../styles/consts.dart';

class CostsRepository {
  final _firebase = FirebaseFirestore.instance;

  List<Category> _categories = [];
  List<Cost> _costs = [];
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  Future<List<Category>> loadCategories() async {
    return _categories;
  }

  Future<List<Cost>> loadCosts() async {
    return _costs;
  }

  Future<DateTime> loadDate() async {
    return _date;
  }

  Future<bool> loadIsLoading() async {
    return _isLoading;
  }

  Future<void> setDate(DateTime date) async {
    _date = date;
  }

  Future<void> setIsLoading(bool isLoading) async {
    _isLoading = isLoading;
  }

  Future<void> requestAllCategories() async {
    QuerySnapshot result = await _firebase
        .collection('categories')
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<DocumentSnapshot> docs = result.docs;
    List<Category> list = [];
    for (var item in docs) {
      bool isDelete = false;
      try {
        isDelete = item.get('isDelete');
      } catch (e) {}
      list.add(Category(item.id, item.reference, item.get('name'),
          item.get('color'), isDelete));
    }

    _categories = list;
  }

  Future<void> requestAllCosts() async {
    QuerySnapshot result = await _firebase
        .collection('costs')
        .where('date', isGreaterThanOrEqualTo: beginningMonth(_date))
        .where('date', isLessThanOrEqualTo: endMonth(_date))
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<DocumentSnapshot> docs = result.docs;
    List<Cost> list = [];

    for (var item in docs) {
      bool isDelete = false;
      try {
        isDelete = item.get('isDelete');
      } catch (e) {}
      list.add(Cost(
          item.id,
          findElement(_categories, item.get('category').id)!,
          item.reference,
          DateTime.fromMillisecondsSinceEpoch(item.get('date').seconds * 1000),
          item.get('sum'),
          isDelete));
    }

    _costs = list;
  }

  Future<void> addCategory(String name, String color) async {
    _firebase.collection('categories').add({
      'name': name,
      'color': color,
      'user': FirebaseAuth.instance.currentUser!.uid,
      'isDelete': false,
    });
  }

  Future<void> addCost(double sum, DateTime date, Category category) async {
    _firebase.collection('costs').add({
      'sum': sum,
      'date': date,
      'user': FirebaseAuth.instance.currentUser!.uid,
      'category': category.reference,
      'isDelete': false,
    });
  }

  Future<void> flagIsDeleteCategory(Category category) async {
    _firebase
        .collection('categories')
        .doc(category.id)
        .update(<String, dynamic>{
      'name': category.name,
      'color': category.color,
      'user': FirebaseAuth.instance.currentUser!.uid,
      'isDelete': !category.isDelete,
    });
  }

  Future<void> flagIsDeleteCost(Cost cost) async {
    _firebase.collection('costs').doc(cost.id).update(<String, dynamic>{
      'sum': cost.sum,
      'date': cost.date,
      'user': FirebaseAuth.instance.currentUser!.uid,
      'isDelete': !cost.isDelete,
    });
  }

  Future<void> deleteCategory(Category category) async {
    QuerySnapshot result = await _firebase
        .collection('costs')
        .where('category', isEqualTo: category.reference)
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<DocumentSnapshot> docs = result.docs;

    for (var item in docs) {
      _firebase.collection('costs').doc(item.id).delete();
    }
    _firebase.collection('categories').doc(category.id).delete();
  }

  Future<void> deleteCost(Cost cost) async {
    _firebase.collection('costs').doc(cost.id).delete();
  }
}

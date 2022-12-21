import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/app_tab.dart';

@immutable
class TabState extends Equatable {
  final AppTab activeTab;

  const TabState({required this.activeTab});

  @override
  List<Object> get props => [activeTab];
}
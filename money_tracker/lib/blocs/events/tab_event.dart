import 'package:equatable/equatable.dart';

import '../../models/app_tab.dart';

abstract class TabEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TabRequested extends TabEvent {
  final AppTab appTab;

  TabRequested(this.appTab);
}
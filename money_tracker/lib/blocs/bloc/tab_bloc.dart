import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/app_tab.dart';
import '../events/tab_event.dart';
import '../states/tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(const TabState(activeTab: AppTab.costs)) {
    on<TabRequested>((event, emit) async {
      switch (event.appTab) {
        case AppTab.costs:
          emit(const TabState(activeTab: AppTab.costs));
          break;
        case AppTab.profile:
          emit(const TabState(activeTab: AppTab.profile));
          break;
      }
    });
  }
}
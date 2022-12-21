import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc/costs_bloc.dart';
import '../blocs/events/tab_event.dart';
import '../blocs/bloc/profile_bloc.dart';
import '../blocs/states/costs_state.dart';
import '../blocs/states/profile_state.dart';
import '../blocs/states/tab_state.dart';
import 'costs_page.dart';
import 'profile_page.dart';
import '../blocs/bloc/tab_bloc.dart';
import '../models/app_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, TabState>(builder: (context, tabState) {
      return Scaffold(
        body: tabState.activeTab == AppTab.costs
            ? BlocBuilder<CostsBloc, CostsState>(
                builder: (context, costsState) {
                return CostsPage(
                  date: costsState.date,
                );
              })
            : BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                return ProfilePage(
                    isSave: profileState.isSave,
                    isLoading: false,
                    imageFile: profileState.imageFile);
                }),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => context
              .read<TabBloc>()
              .add(TabRequested(AppTab.values[index])),
          currentIndex: AppTab.values.indexOf(tabState.activeTab),
          items: AppTab.values.map((tab) {
            return BottomNavigationBarItem(
              icon: Icon(
                tab == AppTab.costs
                    ? Icons.library_books_outlined
                    : Icons.person,
              ),
              label: tab == AppTab.costs ? 'Расходы' : 'Профиль',
            );
          }).toList(),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

import '../blocs/bloc/costs_bloc.dart';
import '../blocs/events/costs_event.dart';
import '../blocs/states/costs_state.dart';
import '../models/category.dart';
import '../models/cost.dart';
import '../models/hex_color.dart';
import '../styles/colors.dart';
import '../styles/consts.dart';
import 'add_category_dialog.dart';
import 'category_card.dart';
import 'loading_indicator.dart';

class CostsPage extends StatelessWidget {
  CostsPage({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  ScrollController controller = ScrollController(initialScrollOffset: 0);

  void _addCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Добавить категорию',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: customColorBlack,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width - 50,
            child: const AddCategoryDialog(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CostsBloc, CostsState>(
      listener: (context, state) async {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: GestureDetector(
              onTap: () async {
                var newDate = (await showMonthPicker(
                  context: context,
                  initialDate: state.date,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  locale: const Locale('ru'),
                ))!;
                BlocProvider.of<CostsBloc>(context).add(SetDateRequested(newDate));
              },
              child: Text(
                  '${upperfirst(DateFormat.MMMM('ru').format(state.date))} ${upperfirst(DateFormat.y('ru').format(state.date))}'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _addCategory(context);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: customColorGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: BlocBuilder<CostsBloc, CostsState>(builder: (context, state) {
                      BlocProvider.of<CostsBloc>(context).add(UpdateDataRequested());
                      return state.isLoading
                          ? const Center(
                              child: LoadingIndicator(),
                            )
                          : PieChartCosts(state);
                    }),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BlocBuilder<CostsBloc, CostsState>(builder: (context, state) {
                    BlocProvider.of<CostsBloc>(context).add(UpdateDataRequested());
                    return state.isLoading
                        ? const Center(
                            child: LoadingIndicator(),
                          )
                        : ListView.builder(
                            controller: controller,
                            itemCount: state.categories.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CategoryCard(
                                  category: state.categories[index],
                                  date: state.date
                              );
                            },
                          );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> getSections(Map<Category, double> mapCosts) {
    int index = -1;
    return mapCosts
        .map<int, PieChartSectionData>((category, sum) {
          index++;
          final value = PieChartSectionData(
            radius: 60,
            color: HexColor.fromHex(category.color),
            value: sum,
            title: category.name,
            borderSide: const BorderSide(width: 0),
          );
          return MapEntry(index, value);
        })
        .values
        .toList();
  }

  Widget PieChartCosts(CostsState state) {
    Map<Category, double> mapCosts = {};
    for (Cost item in (state.costs)) {
      if (mapCosts[item.category] == null) {
        mapCosts.addAll({item.category: item.sum});
      } else {
        mapCosts[item.category] =
            (mapCosts[item.category] ?? 0) + item.sum;
      }
    }
    if (mapCosts.isEmpty) {
      return Center(
        child: Text(
          'За ${upperfirst(DateFormat.MMMM('ru').format(state.date))} нет расходов',
          style: TextStyle(
            color: customColorBlack,
            fontSize: 15,
          ),
        ),
      );
    } else {
      return PieChart(
        PieChartData(
          sections: getSections(mapCosts),
        ),
      );
    }
  }
}

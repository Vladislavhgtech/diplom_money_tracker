import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/models/hex_color.dart';

import '../blocs/bloc/costs_bloc.dart';
import '../blocs/events/costs_event.dart';
import '../blocs/states/costs_state.dart';
import '../models/category.dart';
import '../models/cost.dart';
import 'detail_category_page.dart';
import '../styles/colors.dart';
import 'add_cost_dialog.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.category, required this.date}) : super(key: key);
  final Category category;
  final DateTime date;

  void _addCost(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Добавить расход',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: customColorBlack,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width - 100,
            child: AddCostDialog(category: category),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CostsBloc, CostsState>(builder: (context, state) {
      return Stack(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            elevation: 5,
            child: SizedBox(
              height: 70.0,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                subtitle: BlocBuilder<CostsBloc, CostsState>(
                    builder: (context, state) {
                  return categoryTotal(state.costs, category);
                }),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: HexColor.fromHex(category.color),
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailCategoryPage(
                            category: category, date: date)));
                  },
                ),
                onTap: () {
                  _addCost(context, category);
                },
                onLongPress: () {
                  BlocProvider.of<CostsBloc>(context).add(FlagIsDeleteCategoryRequested(category));
                },
              ),
            ),
          ),
          if (category.isDelete)
            Positioned(
              right: 10,
              top: 10,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            style: TextStyle(
                              color: customColorBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: 'Удалить категорию ',
                              ),
                              TextSpan(
                                text: category.name,
                                style: TextStyle(
                                  color: customColorViolet,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: '?',
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            key: const Key('buttonWait'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50.0),
                              primary: customColorViolet,
                              onPrimary: customColorWhite,
                              textStyle: const TextStyle(fontSize: 17),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              BlocProvider.of<CostsBloc>(context).add(DeleteCategoryRequested(category));
                            },
                            child: const Text('Подтвердить'),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text(
                                'Отмена',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 70),
                  primary: customColorDelete,
                  onPrimary: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 15.0,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                ),
                child: const Text('Удалить'),
              ),
            ),
        ],
      );
    });
  }

  Widget categoryTotal(List<Cost> costs, Category category) {
    List<Cost> list = loadCostsOneCategory(costs, category);

    double sum = 0;
    for (var item in list) {
      sum += item.sum;
    }
    return Text(
      sum == 0 ? 'Добавить расход' : 'Всего: $sum',
      style: const TextStyle(
        fontSize: 10,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/bloc/costs_bloc.dart';
import '../blocs/events/costs_event.dart';
import '../blocs/states/costs_state.dart';
import '../models/cost.dart';
import '../styles/colors.dart';

class CostCard extends StatelessWidget {
  const CostCard({Key? key, required this.cost}) : super(key: key);
  final Cost cost;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CostsBloc, CostsState>(builder: (context, state)
    {
      return Stack(
        key: UniqueKey(),
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            elevation: 5,
            child: SizedBox(
              height: 70,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  cost.sum.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  DateFormat('dd MMMM yyyy / HH:mm', 'ru').format(
                      cost.date),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                onLongPress: () {
                  BlocProvider.of<CostsBloc>(context).add(FlagIsDeleteCostRequested(cost));
                },
              ),
            ),
          ),
          if (cost.isDelete)
            Positioned(
              right: 10,
              top: 10,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Удалить данные о расходе? ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: customColorBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              BlocProvider.of<CostsBloc>(context).add(DeleteCostRequested(cost));
                            },
                            child: const Text('Подтвердить'),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: Navigator
                                  .of(context)
                                  .pop,
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
}
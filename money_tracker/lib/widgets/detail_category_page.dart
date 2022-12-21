import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc/costs_bloc.dart';
import '../blocs/states/costs_state.dart';
import '../models/category.dart';
import '../models/cost.dart';
import '../models/hex_color.dart';
import '../styles/colors.dart';
import 'loading_indicator.dart';
import 'cost_card.dart';

class DetailCategoryPage extends StatelessWidget {
  const DetailCategoryPage({Key? key, required this.category, required this.date}) : super(key: key);
  final Category category;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Final Project',
      theme: ThemeData(
        primarySwatch: MaterialColor(
            int.parse(HexColor.toHex(HexColor.fromHex(category.color)), radix: 16), paletteOfShades
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(category.name),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<CostsBloc, CostsState>(builder: (context, state) {
            List<Cost> list = loadCostsOneCategory(state.costs, category);
            return state.isLoading
                ? const Center(
                    child: LoadingIndicator(),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CostCard(cost: list[index]);
                    },
                  );
          }),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/bloc/costs_bloc.dart';
import '../blocs/events/costs_event.dart';
import '../models/category.dart';
import '../styles/colors.dart';

class AddCostDialog extends StatefulWidget {
  const AddCostDialog({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  _AddCostDialogState createState() => _AddCostDialogState();
}

class _AddCostDialogState extends State<AddCostDialog> {
  late final FocusNode focusCost = FocusNode()..addListener(() {
    setState(() {});
  });
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late DateTime date;
  String? sum;

  final styleBorderFocus = OutlineInputBorder(
    borderSide: BorderSide(
      color: customColorViolet,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  );

  final styleBorderEnable = OutlineInputBorder(
    borderSide: BorderSide(
      color: customColorGrey,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  );

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
  }

  @override
  void dispose() {
    focusCost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              date = (await showDatePicker(
                context: context,
                initialDate: date,
                initialEntryMode: DatePickerEntryMode.input,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                locale: const Locale('ru'),
              ))!;
            },
            child: Text(
              DateFormat('dd MMM yyyy', 'ru').format(date),
              style: TextStyle(
                color: customColorBlack,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            key: const Key('text1'),
            validator: (value) {
              sum = value;
              if (value == '') return 'Введите сумму';
              return null;
            },
            focusNode: focusCost,
            decoration: InputDecoration(
              labelText: 'Введите сумму',
              labelStyle: TextStyle(color: focusCost.hasFocus ? customColorViolet : customColorGrey),
              focusedBorder: styleBorderFocus,
              enabledBorder: styleBorderEnable,
            ),
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: false),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              TextInputFormatter.withFunction((oldValue, newValue) {
                try {
                  final text = newValue.text;
                  if (text.isNotEmpty) double.parse(text);
                  return newValue;
                } catch (e) {}
                return oldValue;
              }),
            ],
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            key: const Key('buttonWait'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50.0),
              primary: customColorViolet,
              onPrimary: customColorWhite,
              textStyle: const TextStyle(fontSize: 17),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                BlocProvider.of<CostsBloc>(context).add(AddCostRequested(double.parse(sum!), date, widget.category));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Добавить'),
          ),
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text(
              'Отмена',
              style: TextStyle(
                color: Colors.red,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

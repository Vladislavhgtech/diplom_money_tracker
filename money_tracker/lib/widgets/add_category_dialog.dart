import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:money_tracker/models/hex_color.dart';

import '../blocs/bloc/costs_bloc.dart';
import '../blocs/events/costs_event.dart';
import '../styles/colors.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late final FocusNode focusText = FocusNode()..addListener(() {
    setState(() {});
  });
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? nameCategory;
  String colorCategory = HexColor.toHex(customColorViolet);

  final styleBorderFocus = UnderlineInputBorder(
    borderSide: BorderSide(
      color: customColorViolet,
    ),
  );

  final styleBorderEnable = UnderlineInputBorder(
    borderSide: BorderSide(
      color: customColorGrey,
    ),
  );

  @override
  void dispose() {
    focusText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            key: const Key('text1'),
            validator: (value) {
              nameCategory = value;
              if (value == '') return 'Введите название';
              return null;
            },
            focusNode: focusText,
            decoration: InputDecoration(
              labelText: 'Название',
              labelStyle: TextStyle(
                  color: focusText.hasFocus ? customColorViolet : customColorGrey),
              focusedBorder: styleBorderFocus,
              enabledBorder: styleBorderEnable,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Цвет',
                    style: TextStyle(color: customColorGrey),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(0),
                          contentPadding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? const BorderRadius.vertical(
                                    top: Radius.circular(500),
                                    bottom: Radius.circular(100),
                                  )
                                : const BorderRadius.horizontal(
                                    right: Radius.circular(500)),
                          ),
                          content: SingleChildScrollView(
                            child: HueRingPicker(
                              pickerColor: HexColor.fromHex(colorCategory),
                              onColorChanged: (color) {
                                setState(() {
                                  colorCategory = HexColor.toHex(color);
                                });
                              },
                              enableAlpha: false,
                              displayThumbColor: false,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: HexColor.fromHex(colorCategory),
                  ),
                  child: const SizedBox(),
                ),
              ),
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
                BlocProvider.of<CostsBloc>(context).add(AddCategoryRequested(nameCategory!, colorCategory));
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

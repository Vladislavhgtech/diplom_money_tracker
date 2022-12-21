import 'package:flutter/material.dart';
import 'package:money_tracker/models/hex_color.dart';

Color customColorViolet = HexColor.fromHex('9053EB');
Color customColorBlack = Colors.black;
Color customColorWhite = Colors.white;
Color customColorGrey = HexColor.fromHex('D0D0D0');
Color customColorDelete = HexColor.fromHex('F36969');

const Map<int, Color> paletteOfShades =
{
  50:Color.fromRGBO(158,158,158, .1),
  100:Color.fromRGBO(158,158,158, .2),
  200:Color.fromRGBO(158,158,158, .3),
  300:Color.fromRGBO(158,158,158, .4),
  400:Color.fromRGBO(158,158,158, .5),
  500:Color.fromRGBO(158,158,158, .6),
  600:Color.fromRGBO(158,158,158, .7),
  700:Color.fromRGBO(158,158,158, .8),
  800:Color.fromRGBO(158,158,158, .9),
  900:Color.fromRGBO(158,158,158, 1),
};

MaterialColor customMaterialColorViolet = const MaterialColor(0xFF9053EB, paletteOfShades);
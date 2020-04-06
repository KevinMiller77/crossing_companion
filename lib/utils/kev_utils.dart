import 'package:flutter/material.dart';

Color hexToColor(String code)
{
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
} 

class KevColor
{
  static Map<int, Color> _color =
  {
  50:Color.fromRGBO(136,14,79, .1),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),
  };

  static Map<int, Color> getColor()
  {
    return _color;
  }

  static MaterialColor getMatColor(int x)
  {
    return MaterialColor(x, _color);
  }

}
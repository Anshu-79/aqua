import 'package:flutter/material.dart';

/// This class stores the theme colors of Aqua
abstract class AquaColors {
  static const Color pink = Color(0xFFff4778);
  static const Color red = Color(0xFFff333a);
  static const Color orange = Color(0xFFff8133);
  static const Color yellow = Color(0xFFffc31f);
  static const Color lime = Color(0xFFc1c62f);
  static const Color green = Color(0xFF82bc24);
  static const Color mint = Color(0xFF48996c);
  static const Color blue = Color(0xFF1f92ea);
  static const Color darkBlue = Color(0xFF0264e1);
  static const Color violet = Color(0xFF7a1ded);

  static List<Color> get allColors =>
      [pink, red, orange, yellow, lime, green, mint, blue, darkBlue, violet];
}

List<Color> textColorizeColors = [
  AquaColors.darkBlue,
  Colors.purple,
  Colors.pink,
  Colors.red,
  Colors.orange,
  Colors.yellow,
];

List<Color> shapeColors = [
  AquaColors.red,
  AquaColors.yellow,
  AquaColors.green,
  AquaColors.blue,
];

/// An extension on [String] to convert a hex color code to a [Color] object 
extension StringExt on String {
  Color toColor() => Color(int.parse('0x$this'));
}

extension ColorExt on Color {
  String toHexCode() => value.toRadixString(16);

  /// Lighten a color by [percent] amount (100 = white)
  Color lighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(alpha, red + ((255 - red) * p).round(),
        green + ((255 - green) * p).round(), blue + ((255 - blue) * p).round());
  }

  MaterialColor toMaterialColor() {
    final int red = this.red;
    final int green = this.green;
    final int blue = this.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };
    return MaterialColor(value, shades);
  }
}

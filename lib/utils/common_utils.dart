import 'package:flutter/material.dart';

import 'utils_importer.dart';

class CommonUtils {
  Size deviceScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}

enum MyThemeKeys { light, dark, darker }

enum OrderTypes { myOrder, allOrder, none }

enum BarcodeRequestType { addBarcode, search, addProduct, attachProduct }

enum ProductsViewTypes { search, category, barcode }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: ColorUtils.primaryColor,
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.black,
    brightness: Brightness.light,
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorUtils.primaryColor))),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: ColorUtils.primaryColor,
    primaryColorLight: Colors.black,
    primaryColorDark: Colors.white,
    brightness: Brightness.dark,
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorUtils.primaryColor))),
  );

  static final ThemeData darkerTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.light:
        return lightTheme;
      case MyThemeKeys.dark:
        return darkTheme;
      case MyThemeKeys.darker:
        return darkerTheme;
      default:
        return lightTheme;
    }
  }
}

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  const _CustomTheme({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final MyThemeKeys initialThemeKey;

  const CustomTheme({
    Key key,
    this.initialThemeKey,
    @required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => CustomThemeState();

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited = (context.dependOnInheritedWidgetOfExactType(aspect: _CustomTheme));

    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited = (context.dependOnInheritedWidgetOfExactType(aspect: _CustomTheme));

    return inherited.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  void initState() {
    _theme = MyThemes.getThemeFromKey(widget.initialThemeKey);
    super.initState();
  }

  void changeTheme(MyThemeKeys themeKey) {
    setState(() {
      _theme = MyThemes.getThemeFromKey(themeKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}

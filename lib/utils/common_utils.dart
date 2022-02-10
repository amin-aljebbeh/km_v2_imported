import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class CommonUtils {
  Size deviceScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}

enum MyThemeKeys { LIGHT, DARK, DARKER }

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
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      case MyThemeKeys.DARKER:
        return darkerTheme;
      default:
        return lightTheme;
    }
  }
}

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
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
  CustomThemeState createState() => new CustomThemeState();

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited =
        // ignore: deprecated_member_use
        (context.inheritFromWidgetOfExactType(_CustomTheme) as _CustomTheme);
    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited =
        // ignore: deprecated_member_use
        (context.inheritFromWidgetOfExactType(_CustomTheme) as _CustomTheme);
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
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}

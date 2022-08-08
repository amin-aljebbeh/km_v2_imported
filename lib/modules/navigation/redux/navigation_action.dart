class PushAndReplace {
  final String routeName;
  final Map<dynamic, dynamic> arguments;

  PushAndReplace({this.routeName, this.arguments});
}

class Push {
  final String routeName;
  final Map<String, dynamic> arguments;

  Push({this.routeName, this.arguments});
}

class Pop {
  final dynamic returnValue;

  Pop({this.returnValue});
}

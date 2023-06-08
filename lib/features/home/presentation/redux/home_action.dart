import '../../../../core/core_importer.dart';

abstract class HomeAction {
  handle({@required Store<AppState> store});
}

class SetPageIndex {
  final int index;

  SetPageIndex({this.index});
}

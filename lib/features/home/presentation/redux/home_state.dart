import '../../../../core/core_importer.dart';
import '../../domain/use_cases/home_use_cases.dart';

@immutable
class HomeState extends Equatable {
  final HomeUseCases homeUseCases;
  final int pageIndex;
  const HomeState({this.homeUseCases, this.pageIndex});

  factory HomeState.initial() {
    return HomeState(homeUseCases: sl<HomeUseCases>(), pageIndex: 0);
  }

  HomeState copyWith({int pageIndex}) {
    return HomeState(homeUseCases: homeUseCases, pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object> get props => [homeUseCases, pageIndex];
}

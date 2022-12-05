import '../../../../core/core_importer.dart';

@immutable
class LoadingState extends Equatable {
  final bool isLoading;

  const LoadingState({@required this.isLoading});

  factory LoadingState.initial() {
    return const LoadingState(isLoading: false);
  }

  LoadingState copyWith({bool isLoading}) {
    return LoadingState(isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object> get props => [isLoading];
}

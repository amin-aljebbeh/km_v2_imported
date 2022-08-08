import 'package:meta/meta.dart';

@immutable
class LoadingState {
  final bool isLoading;

  const LoadingState({@required this.isLoading});

  factory LoadingState.initial() {
    return const LoadingState(isLoading: false);
  }

  LoadingState copyWith({bool isLoading}) {
    return LoadingState(isLoading: isLoading ?? this.isLoading);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingState && runtimeType == other.runtimeType && isLoading == other.isLoading;

  @override
  int get hashCode => super.hashCode;
}

import '../../../../core/core_importer.dart';

@immutable
class LoadingState extends Equatable {
  final List<int> loading;
  final String message;

  const LoadingState({@required this.loading, this.message});

  factory LoadingState.initial() {
    return const LoadingState(loading: [], message: '');
  }

  LoadingState copyWith({List<int> loading, String message}) {
    return LoadingState(loading: loading ?? this.loading, message: message ?? this.message);
  }

  @override
  List<Object> get props => [loading, message];
}

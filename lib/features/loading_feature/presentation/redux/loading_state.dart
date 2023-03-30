import '../../../../core/core_importer.dart';

@immutable
class LoadingState extends Equatable {
  final List<int> loading;
  final bool viewMessage;
  final String message;

  const LoadingState({@required this.loading, this.viewMessage, this.message});

  factory LoadingState.initial() {
    return const LoadingState(loading: [], viewMessage: false, message: '');
  }

  LoadingState copyWith({List<int> loading, bool viewMessage, String message}) {
    return LoadingState(
        loading: loading ?? this.loading,
        message: message ?? this.message,
        viewMessage: viewMessage ?? this.viewMessage);
  }

  @override
  List<Object> get props => [loading, viewMessage, message];
}

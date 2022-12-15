import '../../../../core/core_importer.dart';

@immutable
class LoadingState extends Equatable {
  final bool isLoading;
  final bool viewMessage;
  final String message;

  const LoadingState({@required this.isLoading, this.viewMessage, this.message});

  factory LoadingState.initial() {
    return const LoadingState(isLoading: false, viewMessage: false, message: '');
  }

  LoadingState copyWith({bool isLoading, bool viewMessage, String message}) {
    return LoadingState(
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        viewMessage: viewMessage ?? this.viewMessage);
  }

  @override
  List<Object> get props => [isLoading, viewMessage, message];
}

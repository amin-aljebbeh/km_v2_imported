import '../../../../core/core_importer.dart';

@immutable
class ErrorState extends Equatable {
  final bool isError;
  final bool viewError;
  final String errorMessage;

  const ErrorState({this.viewError, @required this.isError, this.errorMessage});

  factory ErrorState.initial() => const ErrorState(isError: false, errorMessage: '', viewError: true);

  ErrorState copyWith({bool isError, String errorMessage, String url, int statusCode, bool viewError}) {
    return ErrorState(
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        viewError: viewError ?? this.viewError);
  }

  @override
  List<Object> get props => [isError, viewError, errorMessage];
}

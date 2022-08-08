import 'package:meta/meta.dart';

@immutable
class ErrorState {
  final bool isError;
  final bool viewError;
  final String errorMessage;
  final String url;
  final int statusCode;

  const ErrorState({this.viewError, this.url, this.statusCode, @required this.isError, this.errorMessage});

  factory ErrorState.initial() {
    return const ErrorState(isError: false, errorMessage: '', url: '', statusCode: 200, viewError: true);
  }

  ErrorState copyWith({bool isError, String errorMessage, String url, int statusCode, bool viewError}) {
    return ErrorState(
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        statusCode: statusCode ?? this.statusCode,
        url: url ?? this.url,
        viewError: viewError ?? this.viewError);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorState &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage &&
          isError == other.isError &&
          statusCode == other.statusCode &&
          viewError == other.viewError &&
          url == other.url;

  @override
  int get hashCode => super.hashCode;
}

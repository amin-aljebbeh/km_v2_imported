class NoError {}

class CatchError {
  final String errorMessage;
  final String reason;
  final bool viewError;

  CatchError({this.viewError = true, this.reason, this.errorMessage});
}

class SetUrl {
  final String url;

  SetUrl({this.url});
}

class SetStatusCode {
  final int statusCode;

  SetStatusCode({this.statusCode});
}

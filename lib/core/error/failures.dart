import '../core_importer.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  @override
  List<Object> get props => [];

  OfflineFailure();
}

class ServerFailure extends Failure {
  @override
  List<Object> get props => [];

  ServerFailure();
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];

  CacheFailure();
}

class InternalFailure extends Failure {
  final String message;

  @override
  List<Object> get props => [];

  InternalFailure({this.message});
}

class OfflineRegionFailure extends Failure {
  final String message;

  @override
  List<Object> get props => [];

  OfflineRegionFailure({this.message});
}

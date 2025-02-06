import 'package:equatable/equatable.dart';

class CancelReasonResponseEntity extends Equatable {
  final bool status;
  final List<CancelReasonEntity> reasons;
  final String message;
  final bool success;

  const CancelReasonResponseEntity({this.status, this.reasons, this.message, this.success});

  @override
  List<Object> get props => [status, reasons, message, success];
}

class CancelReasonEntity extends Equatable {
  final int id;
  final String name;

  const CancelReasonEntity({this.id, this.name});

  @override
  List<Object> get props => [id, name];
}

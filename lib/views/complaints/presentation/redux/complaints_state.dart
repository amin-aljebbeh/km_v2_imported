import 'package:kammun_app/views/complaints/domain/use_cases/complaints_usecases.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/complaint_entity.dart';

@immutable
class ComplaintsState extends Equatable {
  final ComplaintsUseCases complaintsUseCases;
  final List<ComplaintEntity> complaints;

  const ComplaintsState({this.complaintsUseCases, this.complaints});

  factory ComplaintsState.initial() {
    return ComplaintsState(complaintsUseCases: sl<ComplaintsUseCases>(), complaints: const []);
  }

  ComplaintsState copyWith({List<ComplaintEntity> complaints}) {
    return ComplaintsState(complaintsUseCases: complaintsUseCases, complaints: complaints ?? this.complaints);
  }

  @override
  List<Object> get props => [complaints];
}

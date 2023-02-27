import 'package:kammun_app/features/complaints/domain/entities/complaint_type_entity.dart';
import 'package:kammun_app/features/complaints/domain/use_cases/complaints_usecases.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/complaint_entity.dart';

@immutable
class ComplaintsState extends Equatable {
  final ComplaintsUseCases complaintsUseCases;
  final List<ComplaintEntity> complaints;
  final List<ComplaintTypeEntity> complaintTypes;

  const ComplaintsState({this.complaintsUseCases, this.complaints, this.complaintTypes});

  factory ComplaintsState.initial() {
    return ComplaintsState(
        complaintsUseCases: sl<ComplaintsUseCases>(), complaints: const [], complaintTypes: const []);
  }

  ComplaintsState copyWith({List<ComplaintEntity> complaints, List<ComplaintTypeEntity> complaintTypes}) {
    return ComplaintsState(
      complaintsUseCases: complaintsUseCases,
      complaints: complaints ?? this.complaints,
      complaintTypes: complaintTypes ?? this.complaintTypes,
    );
  }

  @override
  List<Object> get props => [complaints, complaintTypes, complaintsUseCases];
}

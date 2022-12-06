import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/admins/domain/use_cases/admins_use_cases.dart';

import '../../../../core/core_importer.dart';

@immutable
class AdminsState extends Equatable {
  final AdminsUseCases adminsUseCases;
  final List<AdminEntity> admins;
  const AdminsState({this.adminsUseCases, this.admins});

  factory AdminsState.initial() {
    return AdminsState(admins: const [], adminsUseCases: sl<AdminsUseCases>());
  }

  AdminsState copyWith({List<AdminEntity> admins}) {
    return AdminsState(adminsUseCases: adminsUseCases, admins: admins ?? this.admins);
  }

  @override
  List<Object> get props => [admins];
}

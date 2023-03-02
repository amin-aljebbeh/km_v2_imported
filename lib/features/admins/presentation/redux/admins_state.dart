import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/admins/domain/use_cases/admins_use_cases.dart';

import '../../../../core/core_importer.dart';

@immutable
class AdminsState extends Equatable {
  final AdminsUseCases adminsUseCases;
  final List<AdminEntity> admins;
  final AdminEntity admin;
  const AdminsState({this.admin, this.adminsUseCases, this.admins});

  factory AdminsState.initial() {
    return AdminsState(admins: const [], admin: null, adminsUseCases: sl<AdminsUseCases>());
  }

  AdminsState copyWith({List<AdminEntity> admins, AdminEntity admin}) {
    return AdminsState(adminsUseCases: adminsUseCases, admins: admins ?? this.admins, admin: admin ?? this.admin);
  }

  @override
  List<Object> get props => [admins, adminsUseCases, admin];
}

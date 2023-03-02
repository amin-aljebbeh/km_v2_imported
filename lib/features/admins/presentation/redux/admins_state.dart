import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/admins/domain/use_cases/admins_use_cases.dart';

import '../../../../core/core_importer.dart';

@immutable
class AdminsState extends Equatable {
  final AdminsUseCases adminsUseCases;
  final List<AdminEntity> admins;
  final List<AdminEntity> transactionsActors;
  final AdminEntity admin;
  const AdminsState({this.admin, this.adminsUseCases, this.admins, this.transactionsActors});

  factory AdminsState.initial() {
    return AdminsState(
        admins: const [], admin: null, adminsUseCases: sl<AdminsUseCases>(), transactionsActors: const []);
  }

  AdminsState copyWith({List<AdminEntity> admins, AdminEntity admin, List<AdminEntity> transactionsActors}) {
    return AdminsState(
      adminsUseCases: adminsUseCases,
      admins: admins ?? this.admins,
      admin: admin ?? this.admin,
      transactionsActors: transactionsActors ?? this.transactionsActors,
    );
  }

  @override
  List<Object> get props => [admins, adminsUseCases, admin, transactionsActors];
}

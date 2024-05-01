import '../../../../core/core_importer.dart';
import '../../domain/use_cases/version_use_cases.dart';

@immutable
class VersionState extends Equatable {
  final VersionUseCases versionUseCases;
  final bool validVersion;

  const VersionState({this.versionUseCases, this.validVersion});

  factory VersionState.initial() {
    return VersionState(versionUseCases: sl<VersionUseCases>(), validVersion: true);
  }

  VersionState copyWith({bool validVersion}) {
    return VersionState(versionUseCases: versionUseCases, validVersion: validVersion);
  }

  @override
  List<Object> get props => [validVersion, versionUseCases];
}

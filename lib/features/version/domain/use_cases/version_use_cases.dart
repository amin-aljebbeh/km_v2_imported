import '../../../../core/core_importer.dart';
import 'check_version_use_case.dart';

class VersionUseCases {
  final CheckVersionUseCase checkVersionUseCase;

  VersionUseCases({@required this.checkVersionUseCase})
      : assert(checkVersionUseCase != null, 'All use cases should be initialized.');
}

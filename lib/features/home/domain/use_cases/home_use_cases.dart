import 'package:kammun_app/core/core_importer.dart';

import 'get_banners_use_case.dart';

class HomeUseCases {
  final GetBannersUseCase getBannersUseCase;

  HomeUseCases({@required this.getBannersUseCase})
      : assert(getBannersUseCase != null, 'All use cases should ne initialized.');
}

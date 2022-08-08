import 'package:meta/meta.dart';

import '../../../core/common_models/supported_city.dart';

@immutable
class SupportedCityState {
  final List<SupportedCityModel> supportedCities;
  const SupportedCityState({this.supportedCities});

  factory SupportedCityState.initial() {
    return const SupportedCityState(supportedCities: []);
  }

  SupportedCityState copyWith({String selectedSupportedCityId, List<SupportedCityModel> supportedCities}) {
    return SupportedCityState(
      supportedCities: supportedCities ?? this.supportedCities,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportedCityState && runtimeType == other.runtimeType && supportedCities == other.supportedCities;

  @override
  int get hashCode => super.hashCode;
}

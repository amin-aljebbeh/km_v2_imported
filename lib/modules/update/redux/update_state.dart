import 'package:meta/meta.dart';

@immutable
class UpdateState {
  final bool optionalUpdate;
  final bool requiredUpdate;
  final String updateUrl;

  const UpdateState({this.requiredUpdate, this.updateUrl, this.optionalUpdate});

  factory UpdateState.initial() {
    return const UpdateState(optionalUpdate: false, updateUrl: '', requiredUpdate: false);
  }

  UpdateState copyWith({bool optionalUpdate, String updateUrl, bool requiredUpdate}) {
    return UpdateState(
      optionalUpdate: optionalUpdate ?? this.optionalUpdate,
      updateUrl: updateUrl ?? this.updateUrl,
      requiredUpdate: requiredUpdate ?? this.requiredUpdate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateState &&
          runtimeType == other.runtimeType &&
          optionalUpdate == other.optionalUpdate &&
          updateUrl == other.updateUrl &&
          requiredUpdate == other.requiredUpdate;

  @override
  int get hashCode => super.hashCode;
}

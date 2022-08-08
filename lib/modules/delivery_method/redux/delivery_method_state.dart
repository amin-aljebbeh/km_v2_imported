import '../../../core/core_importer.dart';

@immutable
class DeliveryMethodState {
  final int selectedDeliveryMethod;
  final List<DeliveryMethodData> deliveryMethods;

  const DeliveryMethodState({this.deliveryMethods, this.selectedDeliveryMethod});

  factory DeliveryMethodState.initial() {
    return const DeliveryMethodState(selectedDeliveryMethod: 0, deliveryMethods: []);
  }

  DeliveryMethodState copyWith({int selectedDeliveryMethod, List<DeliveryMethodData> deliveryMethods}) {
    return DeliveryMethodState(
      selectedDeliveryMethod: selectedDeliveryMethod ?? this.selectedDeliveryMethod,
      deliveryMethods: deliveryMethods ?? this.deliveryMethods,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryMethodState &&
          runtimeType == other.runtimeType &&
          selectedDeliveryMethod == other.selectedDeliveryMethod &&
          deliveryMethods == other.deliveryMethods;

  @override
  int get hashCode => super.hashCode;
}

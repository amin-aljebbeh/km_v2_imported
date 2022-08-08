import '../../../core/common_models/delivery_method_model.dart';

class GetDeliveryMethods {
  final int addressId;

  GetDeliveryMethods({this.addressId});
}

class InitialDeliveryMethod {}

class DeliveryMethodsFetchedSuccessfully {
  final List<DeliveryMethodData> deliveryMethods;

  DeliveryMethodsFetchedSuccessfully({this.deliveryMethods});
}

class SelectDeliveryMethod {
  final int selectedDeliveryMethod;

  SelectDeliveryMethod({this.selectedDeliveryMethod});
}

import '../../../cart/domain/entities/changed_price_product_entity.dart';

class ChangedPriceProductModel extends ChangedPriceProductEntity {
  ChangedPriceProductModel({id, oldPrice, newPrice}) : super(id: id, newPrice: newPrice, oldPrice: oldPrice);

  factory ChangedPriceProductModel.fromJson(Map<String, dynamic> json) =>
      ChangedPriceProductModel(id: json['id'], oldPrice: json['old_price'], newPrice: json['new_price']);

  Map<String, dynamic> toJson() => {'id': id, 'old_price': oldPrice, 'new_price': newPrice};
}

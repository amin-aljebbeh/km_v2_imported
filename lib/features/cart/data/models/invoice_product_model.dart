import '../../domain/entities/invoice_product_entity.dart';

class InvoiceProductModel extends InvoiceProductEntity {
  InvoiceProductModel({productId, quantity, price}) : super(price: price, quantity: quantity, productId: productId);

  factory InvoiceProductModel.fromJson(Map<String, dynamic> json) =>
      InvoiceProductModel(productId: json['product_id'], quantity: json['quantity'], price: json['price']);

  Map<String, dynamic> toJson() => {'product_id': productId, 'quantity': quantity, 'price': price};
}

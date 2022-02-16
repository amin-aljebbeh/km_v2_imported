class NonIntroducedProduct {
  NonIntroducedProduct({
    this.nameProduct,
    this.supplierCode,
  });

  String nameProduct;
  String supplierCode;

  factory NonIntroducedProduct.fromJson(Map<String, dynamic> json) => NonIntroducedProduct(
        nameProduct: json["nameProduct"] == null ? null : json["nameProduct"],
        supplierCode: json["supplierCode"] == null ? null : json["supplierCode"],
      );

  Map<String, dynamic> toJson() => {
        "nameProduct": nameProduct == null ? null : nameProduct,
        "supplierCode": supplierCode == null ? null : supplierCode,
      };
}

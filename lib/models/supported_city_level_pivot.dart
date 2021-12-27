class SupportedCityLevelPivot {
  SupportedCityLevelPivot({
    this.levelId,
    this.supportedCityId,
    this.deliveryProfitPercentage,
  });

  String levelId;
  String supportedCityId;
  double deliveryProfitPercentage;

  factory SupportedCityLevelPivot.fromJson(Map<String, dynamic> json) =>
      SupportedCityLevelPivot(
        levelId: json["level_id"] == null ? null : json["admin_id"],
        supportedCityId:
            json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
        deliveryProfitPercentage: json["delivery_profit_percentage"] == null
            ? null
            : double.parse(json["delivery_profit_percentage"]),
      );

  Map<String, dynamic> toJson() => {
        "level_id": levelId == null ? null : levelId,
        "sub_warehouse_id": supportedCityId == null ? null : supportedCityId,
        "delivery_profit_percentage":
            deliveryProfitPercentage == null ? null : deliveryProfitPercentage,
      };
}

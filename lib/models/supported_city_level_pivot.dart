class SupportedCityLevelPivot {
  SupportedCityLevelPivot({
    this.levelId,
    this.supportedCityId,
    this.deliveryProfitPercentage,
  });

  int levelId;
  int supportedCityId;
  double deliveryProfitPercentage;

  factory SupportedCityLevelPivot.fromJson(Map<String, dynamic> json) => SupportedCityLevelPivot(
        levelId: json["level_id"],
        supportedCityId: json["sub_warehouse_id"],
        deliveryProfitPercentage:
            json["delivery_profit_percentage"] == null ? null : double.parse(json["delivery_profit_percentage"]),
      );

  Map<String, dynamic> toJson() => {
        "level_id": levelId,
        "sub_warehouse_id": supportedCityId,
        "delivery_profit_percentage": deliveryProfitPercentage,
      };
}

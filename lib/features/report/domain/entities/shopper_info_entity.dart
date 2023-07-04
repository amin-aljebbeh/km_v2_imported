class ShopperInfoEntity {
  ShopperInfoEntity(
      {this.shopperId, this.name, this.companyDues, this.totalProfits, this.avgDeliveryMinutes, this.avgOrderRating});

  int shopperId;
  String name;
  String companyDues;
  String totalProfits;
  String avgDeliveryMinutes;
  String avgOrderRating;
}

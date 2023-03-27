class ShopperReportEntity {
  ShopperReportEntity({
    this.success,
    this.monthlyProfits,
    this.countOrderThisMonth,
    this.workingHour,
    this.avgOrderRating,
    this.avgDeliveryMinutes,
    this.deliveryDistance,
    this.dailyProfits,
  });

  bool success;
  int monthlyProfits;
  int dailyProfits;
  int countOrderThisMonth;
  String workingHour;
  String avgOrderRating;
  String avgDeliveryMinutes;
  String deliveryDistance;
}

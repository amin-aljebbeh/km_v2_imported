class ShopperReportEntity {
  ShopperReportEntity({
    this.monthlyProfits,
    this.countOrderThisMonth,
    this.workingHour,
    this.avgOrderRating,
    this.avgDeliveryMinutes,
    this.deliveryDistance,
    this.dailyProfits,
  });

  String monthlyProfits;
  String dailyProfits;
  String countOrderThisMonth;
  String workingHour;
  String avgOrderRating;
  String avgDeliveryMinutes;
  String deliveryDistance;
}

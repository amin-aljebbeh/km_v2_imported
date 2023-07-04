class ActivityHoursEntity {
  ActivityHoursEntity({
    this.id,
    this.shopperId,
    this.numberMinutes,
    this.startWorkAt,
    this.endAt,
  });

  int id;
  int shopperId;
  int numberMinutes;
  DateTime startWorkAt;
  DateTime endAt;
}

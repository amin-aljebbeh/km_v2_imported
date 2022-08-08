class StartModelWarehouse {
  StartModelWarehouse({
    this.id,
    this.workStartTime,
    this.workEndTime,
    this.fridayStartTime,
    this.fridayEndTime,
  });

  int id;
  String workStartTime;
  String workEndTime;
  String fridayStartTime;
  String fridayEndTime;

  factory StartModelWarehouse.fromJson(Map<String, dynamic> json) => StartModelWarehouse(
        id: json['id'],
        workStartTime: json['work_start_time'],
        workEndTime: json['work_end_time'],
        fridayStartTime: json['friday_start_time'],
        fridayEndTime: json['friday_end_time'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'work_start_time': workStartTime,
        'work_end_time': workEndTime,
        'friday_start_time': fridayStartTime,
        'friday_end_time': fridayEndTime,
      };
}

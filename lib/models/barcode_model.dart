class Barcode {
  Barcode({
    this.id,
  });

  int id;

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
      };
}

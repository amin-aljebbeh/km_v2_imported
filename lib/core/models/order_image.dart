class OrderImage {
  OrderImage({this.id, this.orderId, this.imageFileName});

  int id;
  int orderId;
  String imageFileName;

  factory OrderImage.fromJson(Map<String, dynamic> json) => OrderImage(
        id: json["id"],
        orderId: json["order_id"],
        imageFileName: json["image_file_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "image_file_name": imageFileName,
      };
}

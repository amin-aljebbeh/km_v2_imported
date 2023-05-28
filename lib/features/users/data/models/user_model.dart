import 'package:kammun_app/features/users/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({id, phone, orderCount, balance})
      : super(id: id, balance: balance, phone: phone, orderCount: orderCount);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], phone: json['phone'], orderCount: json['order_count'] ?? -1, balance: json['balance']);

  Map<String, dynamic> toJson() => {'id': id, 'phone': phone};
}

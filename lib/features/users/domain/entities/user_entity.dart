import 'package:kammun_app/core/core_importer.dart';

class UserEntity extends Equatable {
  final int id;
   String phone;
  final String balance;
  final int orderCount;

   UserEntity({this.id, this.phone, this.balance, this.orderCount});

  UserEntity copyWith({int id, String phone, String balance, int orderCount}) => UserEntity(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      orderCount: orderCount ?? this.orderCount);

  UserEntity copyFrom({UserEntity userEntity}) => UserEntity(
      id: userEntity.id ?? id,
      phone: userEntity.phone ?? phone,
      balance: userEntity.balance ?? balance,
      orderCount: userEntity.orderCount ?? orderCount);

  @override
  List<Object> get props => [id, phone, balance, orderCount];
}

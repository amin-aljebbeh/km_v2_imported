import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/coupons/domain/entities/coupons_pagination_entity.dart';

class GetCouponsResponseEntity extends Equatable {
  final bool success;
  final CouponsPaginationEntity data;

  const GetCouponsResponseEntity({this.success, this.data});
  @override
  List<Object> get props => [data, success];
}

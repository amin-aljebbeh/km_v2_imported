import '../../../../core/core_importer.dart';

class BannerEntity extends Equatable {
  const BannerEntity({
    this.id,
    this.title,
    this.description,
    this.imageFileName,
    this.expirationDate,
    this.warehouseId,
    this.bannerLink
  });

  final int id;
  final String title;
  final String description;
  final String bannerLink;
  final String imageFileName;
  final DateTime expirationDate;
  final int warehouseId;

  @override
  List<Object> get props => [id, title, description, imageFileName, expirationDate, warehouseId, bannerLink];
}

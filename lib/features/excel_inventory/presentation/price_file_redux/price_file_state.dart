import '../../../../core/core_importer.dart';
import '../../domain/entities/price_file_product_entity.dart';

@immutable
class PriceFileState extends Equatable {
  final PriceFileProductEntity priceFileProductEntity;
  final bool priceSent;
  final int priceSelected;
  final bool loading;
  final bool error;

  const PriceFileState({this.loading, this.error, this.priceFileProductEntity, this.priceSent, this.priceSelected});

  factory PriceFileState.initial() {
    return PriceFileState(
      priceSelected: 0,
      priceSent: false,
      loading: false,
      error: false,
      priceFileProductEntity: PriceFileProductEntity(productsPriceChange: [], nonIntroducedProducts: []),
    );
  }

  PriceFileState copyWith({
    PriceFileProductEntity priceFileProductEntity,
    bool priceSent,
    int priceSelected,
    bool loading,
    bool error,
  }) {
    return PriceFileState(
      priceSelected: priceSelected ?? this.priceSelected,
      priceSent: priceSent ?? this.priceSent,
      priceFileProductEntity: priceFileProductEntity ?? this.priceFileProductEntity,
      error: error ?? this.error,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object> get props => [priceSelected, priceSent, priceFileProductEntity, error, loading];
}

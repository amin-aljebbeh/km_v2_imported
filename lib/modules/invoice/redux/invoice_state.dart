import '../../../core/core_importer.dart';

@immutable
class InvoiceState {
  final CheckInvoiceModel invoice;
  final InvoiceViewWidgetModel invoiceView;
  final bool showCancelCoupon;
  const InvoiceState({this.showCancelCoupon, this.invoiceView, this.invoice});

  factory InvoiceState.initial() {
    return InvoiceState(
        invoice: CheckInvoiceModel(), invoiceView: InvoiceViewWidgetModel(), showCancelCoupon: false);
  }

  InvoiceState copyWith({CheckInvoiceModel invoice, InvoiceViewWidgetModel invoiceView, bool showCancelCoupon}) {
    return InvoiceState(
      invoice: invoice ?? this.invoice,
      invoiceView: invoiceView ?? this.invoiceView,
      showCancelCoupon: showCancelCoupon ?? this.showCancelCoupon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceState &&
          runtimeType == other.runtimeType &&
          invoice == other.invoice &&
          showCancelCoupon == other.showCancelCoupon &&
          invoiceView == other.invoiceView;

  @override
  int get hashCode => super.hashCode;
}

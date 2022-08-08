import '../../../core/core_importer.dart';

@immutable
class AddressState {
  final List<AddressModel> addresses;
  final int selectedIndex;
  final int editingIndex;
  const AddressState({this.editingIndex, this.addresses, this.selectedIndex});

  factory AddressState.initial() {
    return const AddressState(selectedIndex: 0, addresses: [], editingIndex: -1);
  }

  AddressState copyWith({List<AddressModel> addresses, int selectedIndex, int editingIndex}) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      editingIndex: editingIndex ?? this.editingIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressState &&
          runtimeType == other.runtimeType &&
          addresses == other.addresses &&
          selectedIndex == other.selectedIndex &&
          editingIndex == other.editingIndex;

  @override
  int get hashCode => super.hashCode;
}

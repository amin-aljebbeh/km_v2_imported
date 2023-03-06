import '../../../../core/core_importer.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({Key key, this.transactionEntity}) : super(key: key);
  final TransactionEntity transactionEntity;

  @override
  Widget build(BuildContext context) {
    return KCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(padding: const EdgeInsets.all(8.0), child: Container()))
        ],
      ),
      radius: const BorderRadius.all(Radius.circular(8)),
    );
  }
}

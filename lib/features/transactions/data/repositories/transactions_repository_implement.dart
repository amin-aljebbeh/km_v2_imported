import '../../../../core/core_importer.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../data_sources/transactions_remote_data_source.dart';

class TransactionsRepositoryImplement extends TransactionsRepository {
  final TransactionRemoteDataSource transactionsRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  TransactionsRepositoryImplement({this.transactionsRemoteDataSource, this.repositoryFactory});
}

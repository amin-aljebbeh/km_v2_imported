import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/sub_warehouse_manager/domain/repositories/sub_warehouse_manager_repository.dart';

import '../../../../core/core_importer.dart';

class PickFileUseCase {
  final SubWarehouseManagerRepository subWarehouseManagerRepository;

  PickFileUseCase({this.subWarehouseManagerRepository});

  Future<Either<Failure, File>> call({String subWarehouseId, File file}) async {
    return await subWarehouseManagerRepository.pickFile();
  }
}

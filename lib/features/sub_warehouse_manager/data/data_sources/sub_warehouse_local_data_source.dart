import 'package:file_picker/file_picker.dart';

import '../../../../core/core_importer.dart';

abstract class SubWarehouseManagerLocalDataSource {
  Future<File> pickFile();
}

class ExcelInventoryLocalDataSourceImplement implements SubWarehouseManagerLocalDataSource {
  @override
  Future<File> pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['xlsx', 'xlsm', 'xlsb', 'xltx', 'xltm', 'xls', 'xlt', 'xls', 'xlw', 'xlr'],
      type: FileType.custom,
    );
    try {
      if (result == null) return null;
      return File(result.files[0].path);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
  }
}

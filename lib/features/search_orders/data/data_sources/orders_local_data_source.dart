import 'package:call_log/call_log.dart';

import '../../../../core/core_importer.dart';

abstract class OrdersLocalDataSource {
  Future<List<CallLogEntry>> getPhoneRecord();
}

class OrdersLocalDataSourceImplement implements OrdersLocalDataSource {
  @override
  Future<List<CallLogEntry>> getPhoneRecord() async {
    try {
      var now = DateTime.now();
      int from = now.subtract(const Duration(days: 2)).millisecondsSinceEpoch;
      int to = now.subtract(const Duration(days: 0)).millisecondsSinceEpoch;
      final Iterable<CallLogEntry> cLog = await CallLog.query(dateFrom: from, dateTo: to);
      return cLog.toList();
    } on PlatformException catch (e, s) {
      throw (LocalException(message: s.toString()));
    }
  }
}

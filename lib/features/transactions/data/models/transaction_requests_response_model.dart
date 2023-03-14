import 'package:kammun_app/features/transactions/data/models/transaction_request_model.dart';

import '../../../../core/core_importer.dart';

TransactionRequestsResponseModel transactionRequestsResponseModelFromJson(String str) =>
    TransactionRequestsResponseModel.fromJson(json.decode(str));

class TransactionRequestsResponseModel {
  TransactionRequestsResponseModel({this.success, this.requests});

  bool success;
  List<TransactionRequestModel> requests;

  factory TransactionRequestsResponseModel.fromJson(Map<String, dynamic> json) => TransactionRequestsResponseModel(
        success: json['success'],
        requests: List<TransactionRequestModel>.from(json['data'].map((x) => TransactionRequestModel.fromJson(x))),
      );
}

import 'package:dartz/dartz.dart';

import '../models/complaint_model.dart';
import '../models/complaint_type_model.dart';

abstract class ComplaintsRemoteDataSource {
  Future<List<ComplaintModel>> getComplaints();
  Future<List<ComplaintTypeModel>> getComplaintTypes();
  Future<Unit> createComplaint({ComplaintModel complaintModel});
}

class ComplaintsRemoteDataSourceImplement implements ComplaintsRemoteDataSource {
  @override
  Future<List<ComplaintModel>> getComplaints() {
    // TODO: implement getComplaints
    throw UnimplementedError();
  }

  @override
  Future<List<ComplaintTypeModel>> getComplaintTypes() {
    // TODO: implement getComplaintTypes
    throw UnimplementedError();
  }

  @override
  Future<Unit> createComplaint({ComplaintModel complaintModel}) {
    // TODO: implement createComplaint
    throw UnimplementedError();
  }
}

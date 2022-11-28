import '../models/complaint_model.dart';

abstract class ComplaintsRemoteDataSource {
  Future<List<ComplaintModel>> getComplaints();
}

class ComplaintsRemoteDataSourceImplement implements ComplaintsRemoteDataSource {
  @override
  Future<List<ComplaintModel>> getComplaints() {
    // TODO: implement getComplaints
    throw UnimplementedError();
  }
}

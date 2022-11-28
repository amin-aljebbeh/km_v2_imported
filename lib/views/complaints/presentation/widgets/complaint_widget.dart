import 'package:kammun_app/views/complaints/domain/entities/complaint_entity.dart';

import '../../../../core/core_importer.dart';

class ComplaintWidget extends StatelessWidget {
  final ComplaintEntity complaintEntity;
  const ComplaintWidget({Key key, this.complaintEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Container());
  }
}

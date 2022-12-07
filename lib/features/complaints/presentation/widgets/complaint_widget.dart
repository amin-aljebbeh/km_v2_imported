import 'package:kammun_app/features/complaints/domain/entities/complaint_entity.dart';

import '../../../../core/core_importer.dart';

class ComplaintWidget extends StatelessWidget {
  final ComplaintEntity complaintEntity;
  const ComplaintWidget({Key key, this.complaintEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KCard(
        padding: const EdgeInsets.all(8),
        onTap: () {},
        child: Column(),
        radius: const BorderRadius.all(Radius.circular(6)));
  }
}

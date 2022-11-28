import 'package:kammun_app/views/complaints/presentation/widgets/complaint_widget.dart';

import '../../../../core/core_importer.dart';
import '../../../loading_feature/presentation/pages/temporary_loading.dart';

class ComplaintsPage extends StatelessWidget {
  static const String routeName = '/ComplaintsPage';
  const ComplaintsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('الشكاوى', style: mainStyle)),
          body: TemporaryLoading(
            child: SafeArea(
              child: state.loadingState.isLoading
                  ? const Center(child: Loader())
                  : state.complaintsState.complaints.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('ليس لديك أكواد حسم', style: paragraphStyle)))
                      : state.errorState.isError
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: state.complaintsState.complaints.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ComplaintWidget(complaintEntity: state.complaintsState.complaints[index]);
                                    },
                                  ),
                                ),
                              ],
                            ),
            ),
          ),
        );
      },
    );
  }
}

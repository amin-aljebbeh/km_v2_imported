import 'package:kammun_app/features/complaints/presentation/widgets/complaint_widget.dart';

import '../../../../core/core_importer.dart';

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
          appBar: AppBar(title: Text('الشكاوى', style: appBarStyle), backgroundColor: kmColors),
          floatingActionButton:
              FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add_rounded), backgroundColor: kmColors),
          body: TemporaryLoading(
            child: SafeArea(
              child: Column(
                children: [
                  DropdownButton(items: const [], onChanged: (value) {}),
                  state.loadingState.isLoading
                      ? const Center(child: Loader())
                      : state.complaintsState.complaints.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text('لا يوجد شكاوى', style: paragraphStyle)))
                          : state.errorState.isError
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                              : Expanded(
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

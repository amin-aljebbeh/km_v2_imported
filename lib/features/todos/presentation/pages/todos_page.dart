import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';
import 'package:kammun_app/features/todos/presentation/widgets/todo_widget.dart';

import '../../../../core/core_importer.dart';
import '../redux/todos_action.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        List<TodoEntity> todos = [];
        todos.addAll(state.todosState.todos);
        return TemporaryLoading(
          child: Scaffold(
            appBar: AppBar(backgroundColor: primaryColor, title: Text('المهام', style: appBarStyle)),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (ScrollEndNotification scrollInfo) {
                        if (state.loadingState.loading.isEmpty &&
                            state.todosState.hasNextTodos &&
                            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                          store.dispatch(SetTodosPageNumber(pageNumber: state.todosState.todoPageNumber + 1));
                          store.dispatch(GetTodosAction());
                        }
                        return;
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: todos == null ? 0 : todos.length,
                        itemBuilder: (BuildContext context, index) {
                          return TodoWidget(todo: todos[index]);
                        },
                      ),
                    ),
                  ),
                  if (state.loadingState.loading.isNotEmpty || !state.todosState.hasNextTodos)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Colors.transparent,
                      child: Center(
                        child: !state.productsState.hasNextProducts
                            ? Text('تم عرض جميع المهام', style: boldStyle)
                            : state.loadingState.loading.isNotEmpty
                                ? const Loader()
                                : const SizedBox(),
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

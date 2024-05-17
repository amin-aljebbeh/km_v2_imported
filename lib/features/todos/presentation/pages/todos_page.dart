import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';
import 'package:kammun_app/features/todos/presentation/widgets/todo_widget.dart';

import '../../../../core/core_importer.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        List<TodoEntity> todos = [];
        todos.addAll(state.todosState.todos);
        return TemporaryLoading(
          child: Scaffold(
            appBar: AppBar(backgroundColor: primaryColor, title: Text('المهام', style: appBarStyle)),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
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
        );
      },
    );
  }
}

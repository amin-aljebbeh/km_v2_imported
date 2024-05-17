import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';
import 'package:kammun_app/features/todos/presentation/redux/todos_action.dart';

import '../../../../core/core_importer.dart';

class TodoWidget extends StatelessWidget {
  final TodoEntity todo;

  const TodoWidget({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KCard(
      radius: const BorderRadius.all(Radius.circular(50)),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          KCacheImage(image: todo.todoTag.imageUrl ?? '', tag: todo.todoTag.id, radius: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(todo.title, style: informationStyle),
              Text(todo.todoTag.name, style: mainStyle),
              Text(todo.todoStatus.name + ' ، ' + todo.warehouse.name, style: mainStyle),
            ],
          )
        ],
      ),
      onTap: () {
        final TextEditingController controller = TextEditingController(text: '');
        showMyDialog(
            title: todo.title,
            context: context,
            dialogButtons: [const CloseWidget()],
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todo.description, style: mainStyle),
                DropdownButton(
                    items: Services.dropdownIntList(
                        inputList: todo.todoTag.todoTagResolvers.map((resolver) => resolver.name).toList()),
                    onChanged: (value) {
                      Navigator.pop(context);
                      StoreProvider.of<AppState>(context).dispatch(ResolveTodoAction(
                          context: context,
                          todoId: todo.id,
                          todoRagResolverId: todo.todoTag.id,
                          note: controller.text));
                    }),
                EntryField(controller: controller, hint: 'ملاحظة', onSubmit: (_) {}, onChange: () {}),
              ],
            ));
      },
    );
  }
}

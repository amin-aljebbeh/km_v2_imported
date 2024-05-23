import 'package:intl/intl.dart';
import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';
import 'package:kammun_app/features/todos/presentation/redux/todos_action.dart';

import '../../../../core/core_importer.dart';

class TodoWidget extends StatelessWidget {
  final TodoEntity todo;

  const TodoWidget({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KCard(
      radius: const BorderRadius.all(Radius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          KCacheImage(image: todo.todoTag.imageUrl ?? '', tag: todo.todoTag.id, radius: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(todo.title, style: informationStyle),
              Text(todo.todoTag.name, style: mainStyle),
              Text(todo.todoStatus.name + ' ، ' + todo.warehouse.name, style: mainStyle),
              Text(DateFormat('a h:mm - dd-MM-yyyy').format(todo.updatedAt ?? todo.createdAt), style: disableStyle),
            ],
          )
        ],
      ),
      onTap: () {
        final TextEditingController controller = TextEditingController(text: todo.note);
        int resolverId = todo.todoTagResolver?.id;
        showMyDialog(
            title: todo.title,
            context: context,
            dialogButtons: [
              const CloseWidget(),
              DialogButton(
                  text: 'تأكيد',
                  onTap: () {
                    Navigator.pop(context);
                    StoreProvider.of<AppState>(context).dispatch(ResolveTodoAction(
                        context: context, todoId: todo.id, todoRagResolverId: resolverId, note: controller.text));
                  })
            ],
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todo.description, style: mainStyle),
                DropdownButton(
                    value: todo.todoTag.todoTagResolvers.indexWhere((resolver) => resolver.id == resolverId) + 1,
                    items: Services.dropdownIntList(
                        inputList: todo.todoTag.todoTagResolvers.map((resolver) => resolver.name).toList()),
                    onChanged: (value) {
                      if (controller.text.isNotEmpty) {
                        resolverId = todo.todoTag.todoTagResolvers[value - 1].id;
                      }
                    }),
                EntryField(controller: controller, hint: 'ملاحظة', onSubmit: (_) {}, onChange: () {}),
              ],
            ));
      },
    );
  }
}

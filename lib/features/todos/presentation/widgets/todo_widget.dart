import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';

import '../../../../core/core_importer.dart';

class TodoWidget extends StatelessWidget {
  final TodoEntity todoEntity;
  const TodoWidget({Key key, this.todoEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          CircleAvatar(child: KCacheImage(image: todoEntity.todoTag.imageUrl, tag: todoEntity.todoTag.id)),
          Column(
            children: [
              Text(todoEntity.title),
              Row(children: [Text(todoEntity.todoTag.name), Text(todoEntity.todoStatus.name)])
            ],
          )
        ],
      ),
      onTap: () {},
    );
  }
}

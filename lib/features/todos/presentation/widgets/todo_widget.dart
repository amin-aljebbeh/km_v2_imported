import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';

import '../../../../core/core_importer.dart';

class TodoWidget extends StatelessWidget {
  final TodoEntity todoEntity;
  const TodoWidget({Key key, this.todoEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: KCard(
        radius: const BorderRadius.all(Radius.circular(50)),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            KCacheImage(image: todoEntity.todoTag.imageUrl ?? '', tag: todoEntity.todoTag.id, radius: 50),
            Column(
              children: [
                Text(todoEntity.title, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                Wrap(children: [Text(todoEntity.todoTag.name + '،'), Text('حالة الطلب: ' + todoEntity.todoStatus.name)])
              ],
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }
}

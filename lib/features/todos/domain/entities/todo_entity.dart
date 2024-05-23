class TodoResponseEntity {
  final bool status;
  final TodosPageEntity data;
  final String message;

  TodoResponseEntity({this.status, this.data, this.message});
}

class TodosPageEntity {
  final int currentPage;
  final List<TodoEntity> data;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;

  TodosPageEntity({this.currentPage, this.data, this.from, this.lastPage, this.perPage, this.to, this.total});
}

class TodoEntity {
  final int id;
  final int todoTagId;
  final int warehouseId;
  final int todoTagResolverId;
  final int todoStatusId;
  final String title;
  final String description;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TodoStatusEntity todoStatus;
  final TodoTagEntity todoTag;
  final TodoResolverEntity todoTagResolver;
  final TodoWarehouseEntity warehouse;

  TodoEntity({
    this.id,
    this.todoTagId,
    this.warehouseId,
    this.todoTagResolverId,
    this.todoStatusId,
    this.title,
    this.description,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.todoStatus,
    this.todoTag,
    this.todoTagResolver,
    this.warehouse,
  });
}

class TodoStatusEntity {
  final int id;
  final String slug;
  final String name;

  TodoStatusEntity({this.id, this.slug, this.name});
}

class TodoResolverEntity {
  final int id;
  final String slug;
  final String name;
  final int todoTagId;

  TodoResolverEntity({this.id, this.slug, this.name, this.todoTagId});
}

class TodoTagEntity {
  final int id;
  final String name;
  final String imageUrl;
  final List<TodoResolverEntity> todoTagResolvers;

  TodoTagEntity({this.id, this.name, this.imageUrl, this.todoTagResolvers});
}

class TodoWarehouseEntity {
  final int id;
  final String name;

  TodoWarehouseEntity({this.id, this.name});
}

// To parse this JSON data, do
//
//     final todoResponseModel = todoResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';

TodoResponseModel todoResponseModelFromJson(String str) => TodoResponseModel.fromJson(json.decode(str));

class TodoResponseModel extends TodoResponseEntity {
  TodoResponseModel({status, data, message}) : super(message: message, data: data, status: status);

  factory TodoResponseModel.fromJson(Map<String, dynamic> json) =>
      TodoResponseModel(status: json["status"], data: TodosPageModel.fromJson(json["data"]), message: json["message"]);
}

class TodosPageModel extends TodosPageEntity {
  TodosPageModel({currentPage, data, from, lastPage, perPage, to, total})
      : super(
          data: data,
          currentPage: currentPage,
          from: from,
          lastPage: lastPage,
          perPage: perPage,
          to: to,
          total: total,
        );

  factory TodosPageModel.fromJson(Map<String, dynamic> json) => TodosPageModel(
        currentPage: json["current_page"],
        data: List<TodoModel>.from(json["data"].map((x) => TodoModel.fromJson(x))),
        from: json["from"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );
}

class TodoModel extends TodoEntity {
  TodoModel({
    id,
    todoTagId,
    warehouseId,
    todoTagResolverId,
    todoStatusId,
    title,
    description,
    note,
    createdAt,
    updatedAt,
    todoStatus,
    todoTag,
    todoTagResolver,
    warehouse,
  }) : super(
          warehouseId: warehouseId,
          createdAt: createdAt,
          description: description,
          id: id,
          note: note,
          title: title,
          todoStatus: todoStatus,
          todoStatusId: todoStatusId,
          todoTag: todoTag,
          todoTagId: todoTagId,
          todoTagResolver: todoTagResolver,
          todoTagResolverId: todoTagResolverId,
          updatedAt: updatedAt,
          warehouse: warehouse,
        );

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        todoTagId: json["todo_tag_id"],
        warehouseId: json["warehouse_id"],
        todoTagResolverId: json["todo_tag_resolver_id"],
        todoStatusId: json["todo_status_id"],
        title: json["title"],
        description: json["description"],
        note: json["note"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        todoStatus: json["todo_status"] == null ? null : TodoStatusModel.fromJson(json["todo_status"]),
        todoTag: json["todo_tag"] == null ? null : TodoTagModel.fromJson(json["todo_tag"]),
        todoTagResolver: null,
        // json["todo_tag_resolver"] == null ? null : TodoResolverModel.fromJson(json["todo_tag_resolver"]),
        warehouse: json["warehouse"] == null ? null : TodoWarehouseModel.fromJson(json["warehouse"]),
      );
}

class TodoStatusModel extends TodoStatusEntity {
  TodoStatusModel({id, slug, name}) : super(id: id, name: name, slug: slug);

  factory TodoStatusModel.fromJson(Map<String, dynamic> json) =>
      TodoStatusModel(id: json["id"], slug: json["slug"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "slug": slug, "name": name};
}

class TodoResolverModel extends TodoResolverEntity {
  TodoResolverModel({id, slug, name}) : super(id: id, name: name, slug: slug);

  factory TodoResolverModel.fromJson(Map<String, dynamic> json) =>
      TodoResolverModel(id: json["id"], slug: json["slug"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "slug": slug, "name": name};
}

class TodoTagModel extends TodoTagEntity {
  TodoTagModel({id, name, imageUrl, todoTagResolvers})
      : super(name: name, id: id, imageUrl: imageUrl, todoTagResolvers: todoTagResolvers);

  factory TodoTagModel.fromJson(Map<String, dynamic> json) => TodoTagModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
        todoTagResolvers:
            List<TodoResolverModel>.from(json["todo_tag_resolvers"].map((x) => TodoResolverModel.fromJson(x))),
      );
}

class TodoWarehouseModel extends TodoWarehouseEntity {
  TodoWarehouseModel({id, name}) : super(id: id, name: name);

  factory TodoWarehouseModel.fromJson(Map<String, dynamic> json) =>
      TodoWarehouseModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

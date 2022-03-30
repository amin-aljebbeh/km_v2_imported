class PermissionPivot {
  PermissionPivot({
    this.adminId,
    this.permissionId,
  });

  int adminId;
  int permissionId;

  factory PermissionPivot.fromJson(Map<String, dynamic> json) => PermissionPivot(
        adminId: json["admin_id"],
        permissionId: json["permission_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId,
        "permission_id": permissionId,
      };
}

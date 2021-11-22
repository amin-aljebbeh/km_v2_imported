class PermissionPivot {
  PermissionPivot({
    this.adminId,
    this.permissionId,
  });

  int adminId;
  int permissionId;

  factory PermissionPivot.fromJson(Map<String, dynamic> json) =>
      PermissionPivot(
        adminId: json["admin_id"] == null ? null : json["admin_id"],
        permissionId:
            json["permission_id"] == null ? null : json["permission_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId == null ? null : adminId,
        "permission_id": permissionId == null ? null : permissionId,
      };
}

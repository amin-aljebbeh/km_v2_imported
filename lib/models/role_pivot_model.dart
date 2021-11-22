class RolePivot {
  RolePivot({
    this.adminId,
    this.roleId,
  });

  int adminId;
  int roleId;

  factory RolePivot.fromJson(Map<String, dynamic> json) => RolePivot(
        adminId: json["admin_id"] == null ? null : json["admin_id"],
        roleId: json["role_id"] == null ? null : json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId == null ? null : adminId,
        "role_id": roleId == null ? null : roleId,
      };
}

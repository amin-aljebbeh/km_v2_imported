class TransactionOperationEntity {
  TransactionOperationEntity({
    this.id,
    this.label,
    this.affectAdmin,
    this.affectActor,
    this.affectUser,
    this.affectShopper,
  });

  int id;
  String label;
  int affectAdmin;
  int affectActor;
  int affectUser;
  int affectShopper;
}

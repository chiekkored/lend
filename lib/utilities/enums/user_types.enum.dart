enum UserType {
  admin('Admin'),
  renter('Renter'),
  owner('Owner');

  final String label;
  const UserType(this.label);
}

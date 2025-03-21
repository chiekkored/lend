enum Status {
  pending('Pending'),
  confirmed('Confirmed'),
  cancelled('Cancelled');

  final String label;
  const Status(this.label);
}

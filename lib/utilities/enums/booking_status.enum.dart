enum BookingStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  cancelled('Cancelled');

  final String label;
  const BookingStatus(this.label);
}

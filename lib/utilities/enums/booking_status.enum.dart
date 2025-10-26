enum BookingStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  declined('Declined'),
  cancelled('Cancelled');

  final String label;
  const BookingStatus(this.label);
}

enum BookingStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  declined('Declined'),
  cancelled('Cancelled');

  final String label;
  const BookingStatus(this.label);

  static BookingStatus fromString(String value) {
    return BookingStatus.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => BookingStatus.pending,
    );
  }
}

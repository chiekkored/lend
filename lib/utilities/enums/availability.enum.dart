enum Availability {
  available('Available', ''),
  underMaintenance(
    'Under Maintenance',
    'This item will still be displayed but not available for rent',
  ),
  hidden('Hidden', '');

  final String label;
  final String subtitle;
  const Availability(this.label, this.subtitle);
}

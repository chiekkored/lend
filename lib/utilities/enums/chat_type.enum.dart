enum ChatType {
  private('Private'),
  group('Group'),
  support('Support');

  final String label;
  const ChatType(this.label);
}

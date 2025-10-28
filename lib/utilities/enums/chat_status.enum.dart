enum ChatStatus {
  active('Active'),
  archived('Archived'),
  deleted('Deleted');

  final String label;
  const ChatStatus(this.label);

  static ChatStatus fromString(String value) {
    return ChatStatus.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ChatStatus.active,
    );
  }
}

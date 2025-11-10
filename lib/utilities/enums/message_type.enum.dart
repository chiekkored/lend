enum MessageType {
  system('System'),
  text('Text'),
  image('Image'),
  video('Video');

  final String label;
  const MessageType(this.label);

  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => MessageType.text,
    );
  }
}

enum MessageType {
  text('Text'),
  image('Image'),
  video('Video');

  final String label;
  const MessageType(this.label);
}

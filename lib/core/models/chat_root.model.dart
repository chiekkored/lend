// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatRoot {
  String? chatType;
  ChatRoot({this.chatType});

  ChatRoot copyWith({String? chatType}) {
    return ChatRoot(chatType: chatType ?? this.chatType);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'chatType': chatType};
  }

  factory ChatRoot.fromMap(Map<String, dynamic> map) {
    return ChatRoot(
      chatType: map['chatType'] != null ? map['chatType'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoot.fromJson(String source) =>
      ChatRoot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatRoot(chatType: $chatType)';

  @override
  bool operator ==(covariant ChatRoot other) {
    if (identical(this, other)) return true;

    return other.chatType == chatType;
  }

  @override
  int get hashCode => chatType.hashCode;
}

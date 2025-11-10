// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lend/utilities/enums/message_type.enum.dart';

class Message {
  String? id;
  String? text;
  String? senderId;
  Timestamp? createdAt;
  MessageType? type;
  String? mediaUrl;
  Message({
    this.id,
    this.text,
    this.senderId,
    this.createdAt,
    this.type,
    this.mediaUrl,
  });

  Message copyWith({
    String? id,
    String? text,
    String? senderId,
    Timestamp? createdAt,
    MessageType? type,
    String? mediaUrl,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'senderId': senderId,
      'createdAt':
          createdAt != null
              ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
              : null,
      'type': type?.label,
      'mediaUrl': mediaUrl,
    }..removeWhere((key, value) => value == null);
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      text: map['text'] != null ? map['text'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      createdAt:
          map['createdAt'] != null
              ? map['createdAt'] is Timestamp
                  ? map['createdAt'] as Timestamp
                  : Timestamp(
                    map['createdAt']['_seconds'],
                    map['createdAt']['_nanoseconds'],
                  )
              : null,
      type: map['type'] != null ? MessageType.fromString(map['type']) : null,
      mediaUrl: map['mediaUrl'] != null ? map['mediaUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, text: $text, senderId: $senderId, createdAt: $createdAt, type: $type, mediaUrl: $mediaUrl)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.senderId == senderId &&
        other.createdAt == createdAt &&
        other.type == type &&
        other.mediaUrl == mediaUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        senderId.hashCode ^
        createdAt.hashCode ^
        type.hashCode ^
        mediaUrl.hashCode;
  }
}

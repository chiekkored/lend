// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lend/core/models/simple_asset.model.dart';

import 'package:lend/core/models/simple_user.model.dart';

class Chat {
  String? id;
  String? chatId;
  SimpleAsset? asset;
  List<SimpleUserModel>? participants;
  String? lastMessage;
  Timestamp? lastMessageDate;
  String? lastMessageSenderId;
  Timestamp? createdAt;
  bool? hasRead;
  Chat({
    this.id,
    this.chatId,
    this.asset,
    this.participants,
    this.lastMessage,
    this.lastMessageDate,
    this.lastMessageSenderId,
    this.createdAt,
    this.hasRead,
  });

  Chat copyWith({
    String? id,
    String? chatId,
    SimpleAsset? asset,
    List<SimpleUserModel>? participants,
    String? lastMessage,
    Timestamp? lastMessageDate,
    String? lastMessageSenderId,
    Timestamp? createdAt,
    bool? hasRead,
  }) {
    return Chat(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      asset: asset ?? this.asset,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      createdAt: createdAt ?? this.createdAt,
      hasRead: hasRead ?? this.hasRead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chatId': chatId,
      'asset': asset?.toMap(),
      'participants': participants?.map((x) => x.toMap()).toList(),
      'lastMessage': lastMessage,
      'lastMessageDate':
          lastMessageDate != null
              ? Timestamp(
                lastMessageDate!.seconds,
                lastMessageDate!.nanoseconds,
              )
              : null,
      'lastMessageSenderId': lastMessageSenderId,
      'createdAt':
          createdAt != null
              ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
              : null,
      'hasRead': hasRead,
    }..removeWhere((key, value) => value == null);
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] != null ? map['id'] as String : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      asset:
          map['asset'] != null
              ? SimpleAsset.fromMap(map['asset'] as Map<String, dynamic>)
              : null,
      participants:
          map['participants'] != null
              ? List<SimpleUserModel>.from(
                (map['participants']).map<SimpleUserModel?>(
                  (x) => SimpleUserModel.fromMap(x as Map<String, dynamic>),
                ),
              )
              : null,
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      lastMessageDate:
          map['lastMessageDate'] != null
              ? map['lastMessageDate'] as Timestamp
              : null,
      lastMessageSenderId:
          map['lastMessageSenderId'] != null
              ? map['lastMessageSenderId'] as String
              : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      hasRead: map['hasRead'] != null ? map['hasRead'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(id: $id, chatId: $chatId, asset: $asset, participants: $participants, lastMessage: $lastMessage, lastMessageDate: $lastMessageDate, lastMessageSenderId: $lastMessageSenderId, createdAt: $createdAt, hasRead: $hasRead)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.chatId == chatId &&
        other.asset == asset &&
        listEquals(other.participants, participants) &&
        other.lastMessage == lastMessage &&
        other.lastMessageDate == lastMessageDate &&
        other.lastMessageSenderId == lastMessageSenderId &&
        other.createdAt == createdAt &&
        other.hasRead == hasRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chatId.hashCode ^
        asset.hashCode ^
        participants.hashCode ^
        lastMessage.hashCode ^
        lastMessageDate.hashCode ^
        lastMessageSenderId.hashCode ^
        createdAt.hashCode ^
        hasRead.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:lend/core/models/simple_user.model.dart';

class UserChats {
  String? id;
  String? assetId;
  List<SimpleUserModel>? participants;
  String? lastMessage;
  Timestamp? lastMessageDate;
  String? lastMessageSenderId;
  Timestamp? createdAt;
  UserChats({
    this.id,
    this.assetId,
    this.participants,
    this.lastMessage,
    this.lastMessageDate,
    this.lastMessageSenderId,
    this.createdAt,
  });

  UserChats copyWith({
    String? id,
    String? assetId,
    List<SimpleUserModel>? participants,
    String? lastMessage,
    Timestamp? lastMessageDate,
    String? lastMessageSenderId,
    Timestamp? createdAt,
  }) {
    return UserChats(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'assetId': assetId,
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
    }..removeWhere((key, value) => value == null);
  }

  factory UserChats.fromMap(Map<String, dynamic> map) {
    return UserChats(
      id: map['id'] != null ? map['id'] as String : null,
      assetId: map['assetId'] != null ? map['assetId'] as String : null,
      participants:
          map['participants'] != null
              ? List<SimpleUserModel>.from(
                (map['participants'] as List<int>).map<SimpleUserModel?>(
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
    );
  }

  String toJson() => json.encode(toMap());

  factory UserChats.fromJson(String source) =>
      UserChats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserChats(id: $id, assetId: $assetId, participants: $participants, lastMessage: $lastMessage, lastMessageDate: $lastMessageDate, lastMessageSenderId: $lastMessageSenderId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserChats other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.assetId == assetId &&
        listEquals(other.participants, participants) &&
        other.lastMessage == lastMessage &&
        other.lastMessageDate == lastMessageDate &&
        other.lastMessageSenderId == lastMessageSenderId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        assetId.hashCode ^
        participants.hashCode ^
        lastMessage.hashCode ^
        lastMessageDate.hashCode ^
        lastMessageSenderId.hashCode ^
        createdAt.hashCode;
  }
}

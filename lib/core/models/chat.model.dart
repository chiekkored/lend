// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lend/core/models/availability.model.dart';
import 'package:lend/core/models/simple_asset.model.dart';

import 'package:lend/core/models/simple_user.model.dart';

class Chat {
  String? id;
  String? chatId;
  String? bookingId;
  String? renterId;
  SimpleAsset? asset;
  List<SimpleUserModel>? participants;
  List<Availability>? availabilities;
  String? lastMessage;
  Timestamp? lastMessageDate;
  String? lastMessageSenderId;
  Timestamp? createdAt;
  bool? hasRead;
  Chat({
    this.id,
    this.chatId,
    this.bookingId,
    this.renterId,
    this.asset,
    this.participants,
    this.availabilities,
    this.lastMessage,
    this.lastMessageDate,
    this.lastMessageSenderId,
    this.createdAt,
    this.hasRead,
  });

  Chat copyWith({
    String? id,
    String? chatId,
    String? bookingId,
    String? renterId,
    SimpleAsset? asset,
    List<SimpleUserModel>? participants,
    List<Availability>? availabilities,
    String? lastMessage,
    Timestamp? lastMessageDate,
    String? lastMessageSenderId,
    Timestamp? createdAt,
    bool? hasRead,
  }) {
    return Chat(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      bookingId: bookingId ?? this.bookingId,
      renterId: renterId ?? this.renterId,
      asset: asset ?? this.asset,
      participants: participants ?? this.participants,
      availabilities: availabilities ?? this.availabilities,
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
      'bookingId': bookingId,
      'renterId': renterId,
      'asset': asset?.toMap(),
      'participants': participants?.map((x) => x.toMap()).toList(),
      'availabilities': availabilities?.map((x) => x.toMap()).toList(),
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
      bookingId: map['bookingId'] != null ? map['bookingId'] as String : null,
      renterId: map['renterId'] != null ? map['renterId'] as String : null,
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
      availabilities:
          map['availabilities'] != null
              ? List<Availability>.from(
                (map['availabilities']).map<Availability?>(
                  (x) => Availability.fromMap(x as Map<String, dynamic>),
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
    return 'Chat(id: $id, chatId: $chatId, bookingId: $bookingId, renterId: $renterId, asset: $asset, participants: $participants, availabilities: $availabilities, lastMessage: $lastMessage, lastMessageDate: $lastMessageDate, lastMessageSenderId: $lastMessageSenderId, createdAt: $createdAt, hasRead: $hasRead)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.chatId == chatId &&
        other.bookingId == bookingId &&
        other.renterId == renterId &&
        other.asset == asset &&
        listEquals(other.participants, participants) &&
        listEquals(other.availabilities, availabilities) &&
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
        bookingId.hashCode ^
        renterId.hashCode ^
        asset.hashCode ^
        participants.hashCode ^
        availabilities.hashCode ^
        lastMessage.hashCode ^
        lastMessageDate.hashCode ^
        lastMessageSenderId.hashCode ^
        createdAt.hashCode ^
        hasRead.hashCode;
  }
}

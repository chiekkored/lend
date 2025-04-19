// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserChatRoot {
  final bool isOnline;
  UserChatRoot({required this.isOnline});

  UserChatRoot copyWith({bool? isOnline}) {
    return UserChatRoot(isOnline: isOnline ?? this.isOnline);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'isOnline': isOnline};
  }

  factory UserChatRoot.fromMap(Map<String, dynamic> map) {
    return UserChatRoot(isOnline: map['isOnline'] as bool);
  }

  String toJson() => json.encode(toMap());

  factory UserChatRoot.fromJson(String source) =>
      UserChatRoot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserChatRoot(isOnline: $isOnline)';

  @override
  bool operator ==(covariant UserChatRoot other) {
    if (identical(this, other)) return true;

    return other.isOnline == isOnline;
  }

  @override
  int get hashCode => isOnline.hashCode;
}

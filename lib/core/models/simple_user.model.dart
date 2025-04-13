class SimpleUserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? photoUrl;
  SimpleUserModel({this.uid, this.firstName, this.lastName, this.photoUrl});
  SimpleUserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    photoUrl = map['photoUrl'];
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl,
    };
  }

  SimpleUserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? photoUrl,
  }) {
    return SimpleUserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    return 'SimpleUserModel(uid: $uid, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(covariant SimpleUserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        photoUrl.hashCode;
  }
}

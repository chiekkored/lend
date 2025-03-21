// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Rates {
  int? daily;
  int? weekly;
  int? monthly;
  int? annually;
  String? notes;
  Rates({
    this.daily,
    this.weekly,
    this.monthly,
    this.annually,
    this.notes,
  });

  Rates copyWith({
    int? daily,
    int? weekly,
    int? monthly,
    int? annually,
    String? notes,
  }) {
    return Rates(
      daily: daily ?? this.daily,
      weekly: weekly ?? this.weekly,
      monthly: monthly ?? this.monthly,
      annually: annually ?? this.annually,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'daily': daily,
      'weekly': weekly,
      'monthly': monthly,
      'annually': annually,
      'notes': notes,
    };
  }

  factory Rates.fromMap(Map<String, dynamic> map) {
    return Rates(
      daily: map['daily'] != null ? map['daily'] as int : null,
      weekly: map['weekly'] != null ? map['weekly'] as int : null,
      monthly: map['monthly'] != null ? map['monthly'] as int : null,
      annually: map['annually'] != null ? map['annually'] as int : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rates.fromJson(String source) =>
      Rates.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Rates(daily: $daily, weekly: $weekly, monthly: $monthly, annually: $annually, notes: $notes)';
  }

  @override
  bool operator ==(covariant Rates other) {
    if (identical(this, other)) return true;

    return other.daily == daily &&
        other.weekly == weekly &&
        other.monthly == monthly &&
        other.annually == annually &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return daily.hashCode ^
        weekly.hashCode ^
        monthly.hashCode ^
        annually.hashCode ^
        notes.hashCode;
  }
}

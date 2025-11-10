// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QrRaw {
  final String? name;
  final List<QrData>? data;

  QrRaw(this.name, this.data);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory QrRaw.fromMap(Map<String, dynamic> map) {
    return QrRaw(
      map['name'] != null ? map['name'] as String : null,
      map['data'] != null
          ? List<QrData>.from(map['data']?.map((x) => QrData.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QrRaw.fromJson(String source) =>
      QrRaw.fromMap(json.decode(source) as Map<String, dynamic>);
}

class QrData {
  final String? displayValue;
  final String? rawValue;
  final List<QrCorners>? corners;
  final QrSize? size;
  final List<int>? rawBytes;

  QrData({
    this.displayValue,
    this.rawValue,
    this.corners,
    this.size,
    this.rawBytes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayValue': displayValue,
      'rawValue': rawValue,
      'corners': corners?.map((x) => x.toMap()).toList(),
      'size': size?.toMap(),
      'rawBytes': rawBytes,
    };
  }

  factory QrData.fromMap(Map<String, dynamic> map) {
    return QrData(
      displayValue: map['displayValue'],
      rawValue: map['rawValue'],
      corners:
          map['corners'] != null
              ? List<QrCorners>.from(
                map['corners']?.map((x) => QrCorners.fromMap(x)),
              )
              : null,
      size: map['size'] != null ? QrSize.fromMap(map['size']) : null,
      rawBytes:
          map['rawBytes'] != null
              ? List<int>.from(map['rawBytes'] as List)
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QrData.fromJson(String source) =>
      QrData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class QrCorners {
  final double? x;
  final double? y;

  QrCorners({this.x, this.y});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'x': x, 'y': y};
  }

  factory QrCorners.fromMap(Map<String, dynamic> map) {
    return QrCorners(
      x: map['x'] != null ? map['x'] as double : null,
      y: map['y'] != null ? map['y'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QrCorners.fromJson(String source) =>
      QrCorners.fromMap(json.decode(source) as Map<String, dynamic>);
}

class QrSize {
  final double? width;
  final double? height;

  QrSize({this.width, this.height});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'width': width, 'height': height};
  }

  factory QrSize.fromMap(Map<String, dynamic> map) {
    return QrSize(
      width: map['width'] != null ? map['width'] as double : null,
      height: map['height'] != null ? map['height'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QrSize.fromJson(String source) =>
      QrSize.fromMap(json.decode(source) as Map<String, dynamic>);
}

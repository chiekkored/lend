// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class FileModel {
  XFile? file;
  double? progress;
  String? storagePath;
  FileModel({this.file, this.progress, this.storagePath});

  FileModel copyWith({XFile? file, double? progress, String? storagePath}) {
    return FileModel(
      file: file ?? this.file,
      progress: progress ?? this.progress,
      storagePath: storagePath ?? this.storagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'progress': progress, 'storagePath': storagePath};
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      progress: map['progress'] != null ? map['progress'] as double : null,
      storagePath:
          map['storagePath'] != null ? map['storagePath'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FileModel.fromJson(String source) =>
      FileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FileModel(file: $file, progress: $progress, storagePath: $storagePath)';

  @override
  bool operator ==(covariant FileModel other) {
    if (identical(this, other)) return true;

    return other.file == file &&
        other.progress == progress &&
        other.storagePath == storagePath;
  }

  @override
  int get hashCode => file.hashCode ^ progress.hashCode ^ storagePath.hashCode;
}

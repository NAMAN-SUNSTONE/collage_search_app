import 'dart:io';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:collection/collection.dart';

class SSFileData {
  late Map<String, String> keys;
  late List<SSFile> files;

  List<SSFile> get local => files
      .where((element) => element.location == SSFileLocation.local)
      .toList();
  List<SSFile> get network => files
      .where((element) => element.location == SSFileLocation.network)
      .toList();

  SSFileData.fromJson(Map<String, dynamic> json) {
    keys = (json['key'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, v.toString()));
    files = [];
    if (json['value'] != null) {
      json['value'].forEach((value) {
        files.add(SSFile.fromJson(value));
      });
    }
  }

  @override
  bool operator ==(Object other) =>
      other is SSFileData &&
      runtimeType == other.runtimeType &&
      ListEquality().equals(files, other.files) &&
      MapEquality().equals(keys, other.keys);
}

class SSFile {
  int? id;
  String? identifier;
  String? label;
  String? url;
  File? file;
  late SSFileLocation location;
  Uint8List? bytes;
  String? fileName;
  String? path;
  String? extension;
  String? explicitMimeType;

  String get mimeType {
    String? mime;

    if (bytes != null) {
      mime = lookupMimeType('', headerBytes: bytes!);
    } else if (file != null) {
      mime = lookupMimeType(file!.path);
    }

    return mime ?? 'application/pdf';
  }

  SSFile({
    this.id,
    this.identifier,
    this.label,
    this.url,
    this.file,
    this.bytes,
    this.fileName,
    this.path,
    this.extension,
    required this.location,
    this.explicitMimeType,
  });

  SSFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['document_name'];
    label = json['document_value'];
    bytes = json['document_bytes'] is List
        ? Uint8List.fromList(
            (json['document_bytes'] as List).map((e) => e as int).toList())
        : null;
    fileName = json['document_filename'];
    extension = json['document_extension'];
    location = SSFileLocation.network;
  }

  SSFile.fromUrl(Map<String, dynamic> json, String key) {
    url = json[key];
    location = SSFileLocation.network;
  }

  @override
  bool operator ==(Object other) {
    if (url != null) {
      return other is SSFile &&
          runtimeType == other.runtimeType &&
          url == other.url;
    } else {
      Function eq = const ListEquality().equals;
      return other is SSFile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          identifier == other.identifier &&
          label == other.label &&
          eq(bytes?.toList(), other.bytes?.toList()) &&
          fileName == other.fileName &&
          extension == other.extension &&
          location == other.location;
    }
  }

  @override
  int get hashCode {
    if (url != null) {
      return url.hashCode;
    } else {
      return Object.hash(
          id, identifier, label, bytes, fileName, extension, location);
    }
  }
}

enum SSFileLocation { local, network }

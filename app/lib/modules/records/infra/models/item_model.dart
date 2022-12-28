// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class GenericItemModel {
  String? id;
  int type;
  dynamic object;
  GenericItemModel(this.type, this.object, [this.id]) {
    id = const Uuid().v4();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'object': object,
    };
  }

  factory GenericItemModel.fromMap(Map<String, dynamic> map) {
    return GenericItemModel(
      map['type'] as int,
      map['object'] as dynamic,
      map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenericItemModel.fromJson(String source) =>
      GenericItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

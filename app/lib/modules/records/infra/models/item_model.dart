// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GenericItemModel {
  String id;
  String type;
  dynamic object;
  GenericItemModel({
    required this.id,
    required this.type,
    required this.object,
  });

  GenericItemModel copyWith({
    String? id,
    String? type,
    dynamic object,
  }) {
    return GenericItemModel(
      id: id ?? this.id,
      type: type ?? this.type,
      object: object ?? this.object,
    );
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
      id: map['id'] as String,
      type: map['type'] as String,
      object: map['object'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenericItemModel.fromJson(String source) =>
      GenericItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GenericItemModel(id: $id, type: $type, object: $object)';

  @override
  bool operator ==(covariant GenericItemModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.type == type && other.object == object;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ object.hashCode;
}

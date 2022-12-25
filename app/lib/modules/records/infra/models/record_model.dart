// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:app_laser_cat/modules/records/infra/models/item_model.dart';
import 'package:collection/collection.dart';

class RecordModel {
  final String name;
  final List<GenericItemModel> itens;

  RecordModel(
    this.name,
    this.itens,
  );

  RecordModel copyWith({
    String? name,
    List<GenericItemModel>? itens,
  }) {
    return RecordModel(
      name ?? this.name,
      itens ?? this.itens,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      map['name'] as String,
      List<GenericItemModel>.from(
        (map['itens'] as List).map<GenericItemModel>(
          (x) => GenericItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordModel.fromJson(String source) =>
      RecordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RecordModel(name: $name, itens: $itens)';

  @override
  bool operator ==(covariant RecordModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name && listEquals(other.itens, itens);
  }

  @override
  int get hashCode => name.hashCode ^ itens.hashCode;
}

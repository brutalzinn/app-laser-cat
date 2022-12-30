// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app_laser_cat/modules/records/infra/models/item_model.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import 'records/record_options.dart';

class RecordModel {
  String? id;
  final String name;
  final List<ItemModel> itens;
  final RecordOptions options;

  RecordModel(this.name, this.itens, this.options, [this.id]) {
    id ??= const Uuid().v4();
  }

  RecordModel copyWith({
    String? id,
    String? name,
    List<ItemModel>? itens,
    RecordOptions? options,
  }) {
    return RecordModel(
      name ?? this.name,
      itens ?? this.itens,
      options ?? this.options,
      id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'itens': itens.map((x) => x.toMap()).toList(),
      'options': options.toMap(),
    };
  }

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
        map['name'] as String,
        List<ItemModel>.from(
          (map['itens'] as List).map<ItemModel>(
            (x) => ItemModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        RecordOptions.fromMap(map['options'] as Map<String, dynamic>),
        map['id'] != null ? map['id'] as String : null);
  }

  String toJson() => json.encode(toMap());

  factory RecordModel.fromJson(String source) =>
      RecordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecordModel(id: $id, name: $name, itens: $itens, options: $options)';
  }

  @override
  bool operator ==(covariant RecordModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        listEquals(other.itens, itens) &&
        other.options == options;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ itens.hashCode ^ options.hashCode;
  }

  void save() {
    final fileProvider = FileProvider();
    fileProvider.write("records/${name}.json", toJson());
  }
}

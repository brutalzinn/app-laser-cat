// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app_laser_cat/modules/joystick/infra/models/coord_package.dart';
import 'package:collection/collection.dart';

class RecordModel {
  final String name;
  final List<CoordPackage> packages;
  RecordModel({
    required this.name,
    required this.packages,
  });

  RecordModel copyWith({
    String? name,
    List<CoordPackage>? packages,
  }) {
    return RecordModel(
      name: name ?? this.name,
      packages: packages ?? this.packages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'packages': packages.map((x) => x.toMap()).toList(),
    };
  }

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      name: map['name'] as String,
      packages: List<CoordPackage>.from(
        (map['packages'] as List).map<CoordPackage>(
          (x) => CoordPackage.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordModel.fromJson(String source) =>
      RecordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RecordModel(name: $name, packages: $packages)';

  @override
  bool operator ==(covariant RecordModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name && listEquals(other.packages, packages);
  }

  @override
  int get hashCode => name.hashCode ^ packages.hashCode;
}

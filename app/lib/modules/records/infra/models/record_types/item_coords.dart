import 'dart:convert';

import 'package:flutter/material.dart';

import 'record_abstract.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ItemCoord extends RecordAbstract {
  int x;
  int y;
  ItemCoord(
    this.x,
    this.y,
  );

  ItemCoord copyWith({
    int? x,
    int? y,
  }) {
    return ItemCoord(
      x ?? this.x,
      y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }

  factory ItemCoord.fromMap(Map<String, dynamic> map) {
    return ItemCoord(
      map['x'] as int,
      map['y'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemCoord.fromJson(String source) =>
      ItemCoord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ItemCoord(x: $x, y: $y)';

  @override
  bool operator ==(covariant ItemCoord other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  Widget build(BuildContext context) {
    return const Text("This is a example of item coords");
  }
}

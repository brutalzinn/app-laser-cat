// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:flutter/material.dart';

import '../record_abstract.dart';

class ItemDelay extends RecordAbstract {
  int value;
  ItemDelay(
    this.value,
  );

  ItemDelay copyWith({
    int? value,
  }) {
    return ItemDelay(
      value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
    };
  }

  factory ItemDelay.fromMap(Map<String, dynamic> map) {
    return ItemDelay(
      map['value'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemDelay.fromJson(String source) =>
      ItemDelay.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ItemDelay(value: $value)';

  @override
  bool operator ==(covariant ItemDelay other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  Widget showDialog(RecordController recordController) {
    // TODO: implement showDialog
    throw UnimplementedError();
  }

  @override
  void onSave() {
    // TODO: implement onSave
  }
}

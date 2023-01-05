// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app_laser_cat/modules/records/infra/models/enums/item_record_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_coords.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_delay.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_laser.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/record_abstract.dart';
import 'package:uuid/uuid.dart';

class ItemModel {
  String? id;
  int type;
  dynamic object;
  RecordAbstract? itemObject;
  ItemModel(this.type, this.object, [this.id]) {
    id ??= const Uuid().v4();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'object': object,
    };
  }

  void loadItem() {
    itemObject = toItem();
  }

  RecordAbstract toItem() {
    if (type == ItemRecordEnum.coord.index) {
      final itemCoord = ItemCoord.fromJson(object);
      return itemCoord;
    }
    if (type == ItemRecordEnum.delay.index) {
      final itemDelay = ItemDelay.fromJson(object);
      return itemDelay;
    }
    final itemLaser = ItemLaser.fromJson(object);
    return itemLaser;
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      map['type'] as int,
      map['object'] as dynamic,
      map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

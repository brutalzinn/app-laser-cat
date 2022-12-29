// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app_laser_cat/modules/records/infra/models/enums/record_types_enum.dart';

class RecordOptions {
  int recordType = RecordTypeEnum.none.index;
  RecordOptions({
    required this.recordType,
  });

  RecordOptions copyWith({
    int? recordType,
  }) {
    return RecordOptions(
      recordType: recordType ?? this.recordType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recordType': recordType,
    };
  }

  factory RecordOptions.fromMap(Map<String, dynamic> map) {
    return RecordOptions(
      recordType: map['recordType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordOptions.fromJson(String source) =>
      RecordOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RecordOptions(recordType: $recordType)';

  @override
  bool operator ==(covariant RecordOptions other) {
    if (identical(this, other)) return true;

    return other.recordType == recordType;
  }

  @override
  int get hashCode => recordType.hashCode;
}

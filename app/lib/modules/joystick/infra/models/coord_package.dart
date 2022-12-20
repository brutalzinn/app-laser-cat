// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CoordPackage {
  final int x;
  final int y;

  CoordPackage(
    this.x,
    this.y,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }

  factory CoordPackage.fromMap(Map<String, dynamic> map) {
    return CoordPackage(
      map['x'] as int,
      map['y'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CoordPackage.fromJson(String source) =>
      CoordPackage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CoordPackage(x: $x, y: $y)';

  @override
  bool operator ==(covariant CoordPackage other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  CoordPackage copyWith({
    int? x,
    int? y,
  }) {
    return CoordPackage(
      x ?? this.x,
      y ?? this.y,
    );
  }
}

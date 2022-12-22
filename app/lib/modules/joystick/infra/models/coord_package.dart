// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CoordPackage {
  final int x;
  final int y;
  final int? delay;

  CoordPackage(this.x, this.y, [this.delay = 1]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
      'delay': delay,
    };
  }

  factory CoordPackage.fromMap(Map<String, dynamic> map) {
    return CoordPackage(
      map['x'] as int,
      map['y'] as int,
      map['delay'] != null ? map['delay'] as int : null,
    );
  }

  // Map toJson() => {'x': x, 'y': y, 'delay': delay};

  String toJson() => json.encode(toMap());

  factory CoordPackage.fromJson(String source) =>
      CoordPackage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CoordPackage(x: $x, y: $y, delay: $delay)';

  @override
  bool operator ==(covariant CoordPackage other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y && other.delay == delay;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ delay.hashCode;

  CoordPackage copyWith({
    int? x,
    int? y,
    int? delay,
  }) {
    return CoordPackage(
      x ?? this.x,
      y ?? this.y,
      delay ?? this.delay,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Settings {
  final int velocity;
  Settings({
    required this.velocity,
  });

  Settings copyWith({
    int? velocity,
  }) {
    return Settings(
      velocity: velocity ?? this.velocity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'velocity': velocity,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      velocity: map['velocity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Settings(velocity: $velocity)';

  @override
  bool operator ==(covariant Settings other) {
    if (identical(this, other)) return true;

    return other.velocity == velocity;
  }

  @override
  int get hashCode => velocity.hashCode;
}

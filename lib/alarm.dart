// alarm.dart

import 'package:flutter/foundation.dart';

class Alarm {
  final int id;
  final DateTime time;
  final String description;

  Alarm({required this.id, required this.time, required this.description});

  Alarm copyWith({int? id, DateTime? time, String? description}) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      description: description ?? this.description,
    );
  }
}

// alarm.dart
import 'package:flutter/foundation.dart';

class Alarm {
  final int id;
  final DateTime time;
  final String description;
  bool isEnabled; // New field to track alarm status

  Alarm({
    required this.id,
    required this.time,
    required this.description,
    this.isEnabled = true, // Default to true when alarm is added
  });

  Alarm copyWith({int? id, DateTime? time, String? description, bool? isEnabled}) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'notification_service.dart';

class Alarm {
  final int id;
  final DateTime time;
  final String description;

  Alarm({required this.id, required this.time, required this.description});

  Alarm copyWith({
    int? id,
    DateTime? time,
    String? description,
  }) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      description: description ?? this.description,
    );
  }
}

class AlarmProvider extends ChangeNotifier {
  List<Alarm> _alarms = [];
  Set<int> _enabledAlarmIds = {};

  List<Alarm> get alarms => _alarms;

  bool isEnabled(int alarmId) => _enabledAlarmIds.contains(alarmId);

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    enableAlarm(alarm.id);
    notifyListeners();
  }

  void removeAlarm(int alarmId) {
    _alarms.removeWhere((alarm) => alarm.id == alarmId);
    _enabledAlarmIds.remove(alarmId);
    notifyListeners();
  }

  void enableAlarm(int alarmId) {
    _enabledAlarmIds.add(alarmId);
    // Schedule alarm logic here if necessary.
    notifyListeners();
  }

  void disableAlarm(int alarmId) {
    _enabledAlarmIds.remove(alarmId);
    notifyListeners();
  }

  void updateAlarm(int id, String newDescription) {
    final alarmIndex = _alarms.indexWhere((alarm) => alarm.id == id);
    if (alarmIndex != -1) {
      _alarms[alarmIndex] = _alarms[alarmIndex].copyWith(description: newDescription);
      notifyListeners();
    }
  }
}

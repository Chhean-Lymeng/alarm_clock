// alarm_provider.dart
import 'package:flutter/foundation.dart';
import 'alarm.dart';

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

  void removeAlarm(Alarm alarm) {
    _alarms.remove(alarm);
    _enabledAlarmIds.remove(alarm.id); // Remove from enabled list if exists
    notifyListeners();
  }

  void enableAlarm(int alarmId) {
    _enabledAlarmIds.add(alarmId);
    notifyListeners();
  }

  void disableAlarm(int alarmId) {
    _enabledAlarmIds.remove(alarmId);
    notifyListeners();
  }

   void updateAlarm(Alarm updatedAlarm) {
    final alarmIndex = _alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
    if (alarmIndex != -1) {
      _alarms[alarmIndex] = updatedAlarm;
      notifyListeners();
    }
  }

  void toggleAlarm(int alarmId) {
    if (isEnabled(alarmId)) {
      disableAlarm(alarmId);
    } else {
      enableAlarm(alarmId);
    }
  }
}

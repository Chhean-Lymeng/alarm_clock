import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'alarm_provider.dart';

class AlarmItem extends StatelessWidget {
  final Alarm alarm;

  const AlarmItem({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}',
        style: TextStyle(fontSize: 24),
      ),
      subtitle: Text(alarm.description),
      trailing: Consumer<AlarmProvider>(
        builder: (context, alarmProvider, child) {
          return Switch(
            value: alarmProvider.isEnabled(alarm.id),
            onChanged: (bool value) {
              if (value) {
                alarmProvider.enableAlarm(alarm.id);
              } else {
                alarmProvider.disableAlarm(alarm.id);
              }
            },
          );
        },
      ),
    );
  }
}

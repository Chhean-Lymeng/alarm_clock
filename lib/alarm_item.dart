import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'alarm_provider.dart' as alarm_provider;
import 'alarm.dart';

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
      trailing: Consumer<alarm_provider.AlarmProvider>(
        builder: (context, alarmProvider, child) {
          final isEnabled = alarmProvider.isEnabled(alarm.id); // Pass alarm id
          return Switch(
            value: isEnabled,
            onChanged: (bool value) {
              if (value) {
                alarmProvider.enableAlarm(alarm.id); // Pass alarm id
              } else {
                alarmProvider.disableAlarm(alarm.id); // Pass alarm id
              }
            },
          );
        },
      ),
    );
  }
}

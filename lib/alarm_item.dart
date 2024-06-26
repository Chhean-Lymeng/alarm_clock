// alarm_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'alarm_provider.dart';
import 'alarm.dart';
import 'edit_alarm_screen.dart'; // Import the EditAlarmScreen widget

class AlarmItem extends StatelessWidget {
  final Alarm alarm;

  const AlarmItem({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => EditAlarmScreen(alarm: alarm),
        );
      },
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
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
        ),
      ),
    );
  }
}

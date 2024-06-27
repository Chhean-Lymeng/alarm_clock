// alarm_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'alarm_provider.dart';
import 'alarm.dart';

class AlarmItem extends StatelessWidget {
  final Alarm alarm;

  const AlarmItem({required this.alarm});

  Future<void> _editAlarm(BuildContext context, Alarm alarm) async {
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(alarm.time);
    TextEditingController descriptionController = TextEditingController(text: alarm.description);

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Edit Alarm', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );

                        if (picked != null && picked != selectedTime) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 150, // Adjust height as needed
                              child: CupertinoTimerPicker(
                                mode: CupertinoTimerPickerMode.hm,
                                initialTimerDuration: Duration(
                                  hours: selectedTime.hour,
                                  minutes: selectedTime.minute,
                                ),
                                onTimerDurationChanged: (Duration newDuration) {
                                  setState(() {
                                    selectedTime = TimeOfDay(
                                      hour: newDuration.inHours,
                                      minute: newDuration.inMinutes % 60,
                                    );
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'description': descriptionController.text,
                              'time': selectedTime,
                            });
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      final description = result['description'] as String;
      final selectedTime = result['time'] as TimeOfDay;
      final now = DateTime.now();
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final updatedAlarm = alarm.copyWith(
        time: alarmTime,
        description: description,
      );

      context.read<AlarmProvider>().updateAlarm(updatedAlarm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _editAlarm(context, alarm),
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

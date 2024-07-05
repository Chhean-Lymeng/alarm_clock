// alarm_item.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'alarm_provider.dart';
import 'alarm.dart';

class AlarmItem extends StatefulWidget {
  final Alarm alarm;

  const AlarmItem({required this.alarm});

  @override
  State<AlarmItem> createState() => _AlarmItemState();
}

class _AlarmItemState extends State<AlarmItem> {
  bool isDarkMode = false;
  Future<void> _editAlarm(BuildContext context, Alarm alarm) async {
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(alarm.time);
    TextEditingController descriptionController =
        TextEditingController(text: alarm.description);

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
                decoration: BoxDecoration(
                  // color: isDarkMode ? Colors.black87 : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Edit Alarm',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
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
                              child: CupertinoTheme(
                                data: CupertinoThemeData(
                                  brightness: isDarkMode
                                      ? Brightness.dark
                                      : Brightness.light,
                                ),
                                child: CupertinoTimerPicker(
                                  mode: CupertinoTimerPickerMode.hm,
                                  initialTimerDuration: Duration(
                                    hours: selectedTime.hour,
                                    minutes: selectedTime.minute,
                                  ),
                                  onTimerDurationChanged:
                                      (Duration newDuration) {
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
                            if (descriptionController.text.isNotEmpty) {
                              Navigator.pop(context, {
                                'description': descriptionController.text,
                                'time': selectedTime,
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Description cannot be empty'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
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
      onTap: () => _editAlarm(context, widget.alarm),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.5),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title: Text(
            '${widget.alarm.time.hour.toString().padLeft(2, '0')}:${widget.alarm.time.minute.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            widget.alarm.description,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          trailing: Consumer<AlarmProvider>(
            builder: (context, alarmProvider, child) {
              return Switch(
                value: alarmProvider.isEnabled(widget.alarm.id),
                onChanged: (bool value) {
                  if (value) {
                    alarmProvider.enableAlarm(widget.alarm.id);
                  } else {
                    alarmProvider.disableAlarm(widget.alarm.id);
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

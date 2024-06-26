// edit_alarm_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino for iOS-style dialogs
import 'package:provider/provider.dart';
import 'alarm_provider.dart' as alarm_provider;
import 'alarm.dart' as alarm_model;

class EditAlarmScreen extends StatefulWidget {
  final alarm_model.Alarm alarm;

  const EditAlarmScreen({required this.alarm});

  @override
  _EditAlarmScreenState createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {
  late TextEditingController _descriptionController;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.alarm.description);
    _selectedTime = TimeOfDay.fromDateTime(widget.alarm.time);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final timeTextColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final TimeOfDay? picked = await showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          _selectedTime.hour,
                          _selectedTime.minute,
                        ),
                        onDateTimeChanged: (DateTime newDateTime) {
                          final selectedTime = TimeOfDay.fromDateTime(newDateTime);
                          setState(() {
                            _selectedTime = selectedTime;
                          });
                        },
                      ),
                    );
                  },
                );

                if (picked != null && picked != _selectedTime) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time:',
                    style: TextStyle(fontSize: 16, color: timeTextColor),
                  ),
                  Text(
                    _selectedTime.format(context),
                    style: TextStyle(fontSize: 16, color: timeTextColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
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
                    final newTime = DateTime(
                      widget.alarm.time.year,
                      widget.alarm.time.month,
                      widget.alarm.time.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                    final updatedAlarm = alarm_model.Alarm(
                      id: widget.alarm.id,
                      time: newTime,
                      description: _descriptionController.text,
                    );
                    context.read<alarm_provider.AlarmProvider>().updateAlarm(updatedAlarm);
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

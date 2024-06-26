import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino for iOS-style dialogs
import 'package:provider/provider.dart';
import 'alarm_provider.dart' as alarm_provider;
import 'alarm.dart' as alarm_model;

class AddAlarmDialog extends StatefulWidget {
  @override
  _AddAlarmDialogState createState() => _AddAlarmDialogState();
}

class _AddAlarmDialogState extends State<AddAlarmDialog> {
  TextEditingController _descriptionController = TextEditingController();
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectTime(BuildContext context) async {
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
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final timeTextColor = isDarkMode ? Colors.white : Colors.black;

    return AlertDialog(
      title: Text('Add Alarm'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              _selectTime(context);
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
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final description = _descriptionController.text;
            final selectedTime = _selectedTime;
            Navigator.of(context).pop({
              'description': description,
              'time': selectedTime,
            });
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

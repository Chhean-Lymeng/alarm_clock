// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'alarm_provider.dart';
import 'alarm_item.dart';
import 'stopwatch_page.dart';
import 'add_alarm_dialog.dart'; // Import the AddAlarmDialog widget
import 'current_time.dart';
import 'edit_alarm_screen.dart'; // Import the EditAlarmScreen widget
import 'alarm.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Alarm Clock'),
          actions: [
            IconButton(
              icon: isDarkMode
                  ? Icon(Icons.light_mode)
                  : Icon(Icons.dark_mode),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Alarm'),
              Tab(text: 'Stopwatch'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Alarm tab
            Column(
              children: [
                CurrentTime(),
                Expanded(
                  child: Consumer<AlarmProvider>(
                    builder: (context, alarmProvider, child) {
                      return ListView.builder(
                        itemCount: alarmProvider.alarms.length,
                        itemBuilder: (context, index) {
                          final alarm = alarmProvider.alarms[index];
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) =>
                                    EditAlarmScreen(alarm: alarm),
                              );
                            },
                            child: AlarmItem(alarm: alarm),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            StopwatchPage(),
          ],
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton(
                onPressed: () async {
                  TimeOfDay selectedTime = TimeOfDay.now(); // Initialize here
                  TextEditingController descriptionController =
                      TextEditingController();

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
                                  TextField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(labelText: 'Description'),
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
                                      ],
                                    ),
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
                                            final description = descriptionController.text;
                                            final now = DateTime.now();
                                            final alarmTime = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              selectedTime.hour,
                                              selectedTime.minute,
                                            );

                                            final alarm = Alarm(
                                              id: now.millisecondsSinceEpoch,
                                              time: alarmTime,
                                              description: description,
                                            );
                                            context.read<AlarmProvider>().addAlarm(alarm);
                                            Navigator.pop(context);
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
                },
                child: Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
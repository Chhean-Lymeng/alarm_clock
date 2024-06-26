// home_screen.dart
import 'package:flutter/material.dart';
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
              icon: isDarkMode ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
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
                                builder: (BuildContext context) => EditAlarmScreen(alarm: alarm),
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
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (BuildContext context) {
                      return AddAlarmDialog();
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

                    final alarm = Alarm(
                      id: now.millisecondsSinceEpoch,
                      time: alarmTime,
                      description: description,
                    );
                    context.read<AlarmProvider>().addAlarm(alarm);
                  }
                },
                child: Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

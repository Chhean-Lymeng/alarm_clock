import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'alarm_provider.dart';
import 'alarm_item.dart';
import 'stopwatch_page.dart';
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
              Tab(text: 'Stopwatchs'),
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
                          final alarms = alarmProvider.alarms[index];
                          return AlarmItem(alarm: alarms);
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
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    final now = DateTime.now();
                    final alarmTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    final alarm = Alarm(dateTime: alarmTime);
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

class CurrentTime extends StatefulWidget {
  @override
  _CurrentTimeState createState() => _CurrentTimeState();
}

class _CurrentTimeState extends State<CurrentTime> {
  TimeOfDay _timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _timeOfDay = TimeOfDay.now();
    });
    Future.delayed(Duration(seconds: 1) - Duration(milliseconds: DateTime.now().millisecond), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        _timeOfDay.format(context),
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }
}

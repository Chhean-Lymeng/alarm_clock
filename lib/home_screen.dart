import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'alarm_provider.dart';
import 'alarm_item.dart';
import 'stopwatch_page.dart';
import 'current_time.dart';
import 'edit_alarm_screen.dart';
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
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Alarm Clock',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
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
              Tab(
                text: 'Alarm',
              ),
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
                  TimeOfDay selectedTime = TimeOfDay.now();
                  TextEditingController descriptionController =
                      TextEditingController();
                  await showModalBottomSheet<Map<String, dynamic>>(
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
                                color:
                                    isDarkMode ? Colors.black87 : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      labelStyle: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black.withOpacity(0.8),
                                      ),
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: selectedTime,
                                      );

                                      if (picked != null &&
                                          picked != selectedTime) {
                                        setState(() {
                                          selectedTime = picked;
                                        });
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 150,
                                            child: CupertinoTheme(
                                              data: CupertinoThemeData(
                                                brightness: isDarkMode
                                                    ? Brightness.dark
                                                    : Brightness.light,
                                              ),
                                              child: CupertinoTimerPicker(
                                                mode:
                                                    CupertinoTimerPickerMode.hm,
                                                initialTimerDuration: Duration(
                                                  hours: selectedTime.hour,
                                                  minutes: selectedTime.minute,
                                                ),
                                                onTimerDurationChanged:
                                                    (Duration newDuration) {
                                                  setState(() {
                                                    selectedTime = TimeOfDay(
                                                      hour: newDuration.inHours,
                                                      minute: newDuration
                                                              .inMinutes %
                                                          60,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.white.withOpacity(0.8)
                                              : Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.white.withOpacity(0.8)
                                              : Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (descriptionController
                                                .text.isNotEmpty) {
                                              final description =
                                                  descriptionController.text;
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
                                              context
                                                  .read<AlarmProvider>()
                                                  .addAlarm(alarm);
                                              Navigator.pop(context);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Description cannot be empty'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text('Save'),
                                        ),
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

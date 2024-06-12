// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'alarm_provider.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlarmProvider(),
      child: Consumer<AlarmProvider>(
        builder: (context, alarmProvider, child) {
          return MaterialApp(
            title: 'Alarm Clock',
            theme: ThemeData.light(), // Light mode theme
            darkTheme: ThemeData.dark(), // Dark mode theme
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Task {
  String title;
  String time;
  DateTime date;
  IconData icon;

  Task(this.title, this.time, this.date, this.icon);
}

final List<Task> allTasks = [
  Task('Meeting with Bob', '10:00 AM', DateTime(2024, 1, 7), Icons.work),
  Task('Doctor Appointment', '2:00 PM', DateTime(2024, 1, 8), Icons.local_hospital),
  Task('Doctor Appointment', '1:00 PM', DateTime(2024, 1, 9), Icons.local_hospital),
  Task('Doctor3 Appointment', '2:00 PM', DateTime(2024, 1, 9), Icons.local_hospital),
  Task('Doctor4 Appointment', '7:00 PM', DateTime(2024, 1, 10), Icons.local_hospital),
  Task('Doctor5 Appointment', '8:00 PM', DateTime(2024, 1, 11), Icons.local_hospital),
  Task('Doctor6 Appointment', '12:00 PM', DateTime(2024, 1, 12), Icons.local_hospital),
  Task('Doctor7 Appointment', '78:00 PM', DateTime(2024, 1, 13), Icons.local_hospital),
  // ... more tasks
];

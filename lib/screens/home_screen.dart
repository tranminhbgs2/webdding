import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:webdding/models/task.dart';
import 'package:webdding/utils/navigation_helper.dart';
import 'package:webdding/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail; // Thông tin email của người dùng đã đăng nhập

  HomeScreen({super.key, required this.userEmail});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Task> _filteredTasks = [];
  int _selectedIndex = 0; // Khởi tạo _selectedIndex ở đây

  @override
  void initState() {
    super.initState();
    _filteredTasks = _getTasksForDay(_selectedDay);
  }

  Map<DateTime, int> _getTaskCounts(List<Task> tasks) {
    Map<DateTime, int> taskCounts = {};
    for (var task in tasks) {
      // Use only the date part for comparison
      DateTime dateOnly =
          DateTime(task.date.year, task.date.month, task.date.day);

      if (taskCounts.containsKey(dateOnly)) {
        taskCounts[dateOnly] = taskCounts[dateOnly]! + 1;
      } else {
        taskCounts[dateOnly] = 1;
      }
    }
    return taskCounts;
  }

  List<Task> _getTasksForDay(DateTime day) {
    return allTasks.where((task) => isSameDay(task.date, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, int> taskCounts = _getTaskCounts(allTasks);
    print(taskCounts.toString());
    DateTime today = DateTime.now();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.userEmail), // Display user's email
          backgroundColor: const Color.fromARGB(
              255, 35, 76, 191), // Set the AppBar color to blue
        ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                  _filteredTasks = _getTasksForDay(selectedDay);
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  int count =
                      taskCounts[DateTime(day.year, day.month, day.day)] ?? 0;
                  bool isToday = isSameDay(day, DateTime.now());
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: TextStyle(
                              color: isToday ? Colors.red : Colors.black),
                        ),
                        if (count > 0)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.blue, // Background color
                                shape: BoxShape.circle, // Circular shape
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                todayBuilder: (context, date, focusedDay) {
                  List<Task> todayTasks = _getTasksForDay(date);

                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4),
                        width: 40, // Đặt chiều rộng của hình tròn
                        height: 40, // Đặt chiều cao của hình tròn
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 159, 150, 241), // Màu sắc cho ngày hiện tại
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (todayTasks.isNotEmpty)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blue, // Màu sắc cho số công việc
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${todayTasks.length}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(task: _filteredTasks[index]);
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Quản lý nhân viên',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_city),
              label: 'Quản lý địa điểm chụp',
            ),
          ],
          currentIndex: _selectedIndex, // Biến theo dõi mục hiện tại được chọn
          selectedItemColor: Colors.amber[800], // Màu sắc cho mục được chọn
          unselectedItemColor:
              Colors.grey, // Màu sắc cho các mục chưa được chọn
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            NavigationHelper.onItemTapped(context, index, widget.userEmail);
          }, // Hàm xử lý sự kiện khi chạm vào một mục
          backgroundColor: Colors.white, // Màu nền của BottomNavigationBar
          type: BottomNavigationBarType.fixed, // Kiểu của BottomNavigationBar
          showUnselectedLabels:
              true, // Hiển thị nhãn của các mục không được chọn
        ));
  }
}

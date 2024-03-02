import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/models/user.dart';
import 'package:webdding/models/work_schedule.dart';
import 'package:webdding/screens/work/add.dart';
import 'package:webdding/services/work/work.dart';
import 'package:webdding/utils/constant.dart';
import 'package:webdding/utils/navigation_helper.dart';
import 'package:webdding/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  // final String userEmail; // Thông tin email của người dùng đã đăng nhập

  const HomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final WorkScheduleService _workScheduleService = WorkScheduleService();
  String role = STAFF;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int _selectedIndex = 0; // Khởi tạo _selectedIndex ở đây

  List<WorkSchedule> allWorkSchedules = [];
  List<WorkSchedule> _filteredWorkSchedules = [];
  List<BottomNavigationBarItem> _navBarItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkSchedulesFromFirestore();
    });
    _loadNavBarItems();
  }

  void _fetchWorkSchedulesFromFirestore() async {
    try {
      final store = StoreProvider.of<AppState>(context);
      final String userCode = store.state.customer?.code ?? '';
      final String userRole = store.state.customer?.rule ?? '';
      allWorkSchedules = await _workScheduleService.getListWork(userCode);
      setState(() {
        _filteredWorkSchedules = _getWorkSchedulesForDay(_selectedDay);
        if (userRole != '') {
          role = userRole;
        }
      });
    } catch (e) {
      // print('Error fetching work schedules: $e');
    }
  }

  Map<DateTime, int> _getWorkScheduleCounts(List<WorkSchedule> workSchedules) {
    Map<DateTime, int> workScheduleCounts = {};
    for (var workSchedule in workSchedules) {
      DateTime dateOnly = workSchedule.shootingDate;
      if (workScheduleCounts.containsKey(dateOnly)) {
        workScheduleCounts[dateOnly] = workScheduleCounts[dateOnly]! + 1;
      } else {
        workScheduleCounts[dateOnly] = 1;
      }
    }
    return workScheduleCounts;
  }

  List<WorkSchedule> _getWorkSchedulesForDay(DateTime day) {
    return allWorkSchedules
        .where((workSchedule) => isSameDay(workSchedule.shootingDate, day))
        .toList();
  }

  Future<void> _loadNavBarItems() async {
    var items = await NavigationHelper.buildBottomNavBarItems();
    setState(() {
      _navBarItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, int> taskCounts = _getWorkScheduleCounts(allWorkSchedules);
    // Remove the unused variable 'today'
    // DateTime today = DateTime.now();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: StoreConnector<AppState, Customer?>(
            converter: (Store<AppState> store) => store.state.customer,
            builder: (BuildContext context, Customer? customer) {
              // Kiểm tra xem customer có phải là null không
              if (customer != null) {
                return Text(
                  "Xin chào, ${customer.name}", // Sử dụng tên của Customer
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              } else {
                return const Text("Khách hàng không xác định");
              }
            },
          ), // Display user's email
          backgroundColor: const Color.fromARGB(255, 35, 76, 191),
          actions: [
            if (role == ADMIN)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                color: Colors.white,
                onPressed: () {
                  // Xử lý khi người dùng nhấn nút "Add Employee" ở đây
                  // Ví dụ: Mở màn hình thêm nhân viên
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddWorkScheduleScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
        body: Column(
          children: [
            TableCalendar(
              locale: 'vi_VN', // Sử dụng locale của thiết bị
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
                  _filteredWorkSchedules = _getWorkSchedulesForDay(selectedDay);
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
                  return Stack(
                    alignment:
                        Alignment.center, // Đặt vị trí chính giữa cho Stack
                    children: [
                      // Text widget cho hiển thị ngày
                      Align(
                        alignment: Alignment.center, // Định vị ở trung tâm
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                              color: isToday ? Colors.red : Colors.black),
                        ),
                      ),
                      if (count > 0)
                        Positioned(
                          bottom: 2,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blue, // Background color
                              shape: BoxShape.circle, // Circular shape
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                todayBuilder: (context, date, focusedDay) {
                  List<WorkSchedule> todayTasks = _getWorkSchedulesForDay(date);

                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4),
                        width: 40, // Đặt chiều rộng của hình tròn
                        height: 40, // Đặt chiều cao của hình tròn
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(
                              255, 159, 150, 241), // Màu sắc cho ngày hiện tại
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
                                fontSize: 12,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Công việc ngày ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (role == ADMIN)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddWorkScheduleScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Thêm công việc',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _filteredWorkSchedules.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có lịch làm việc',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredWorkSchedules.length,
                      itemBuilder: (context, index) {
                        return TaskItem(
                            workSchedule: _filteredWorkSchedules[index]);
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _navBarItems,
          currentIndex: _selectedIndex, // Biến theo dõi mục hiện tại được chọn
          selectedItemColor: Colors.amber[800], // Màu sắc cho mục được chọn
          unselectedItemColor:
              Colors.grey, // Màu sắc cho các mục chưa được chọn
          onTap: (index) {
            if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
              });
              NavigationHelper.onItemTapped(context, index);
            }
          }, // Hàm xử lý sự kiện khi chạm vào một mục
          backgroundColor: Colors.white, // Màu nền của BottomNavigationBar
          type: BottomNavigationBarType.fixed, // Kiểu của BottomNavigationBar
          showUnselectedLabels:
              true, // Hiển thị nhãn của các mục không được chọn
        ));
  }
}

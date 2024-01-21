import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webdding/models/work_schedule.dart';
import 'package:webdding/screens/work/update.dart';
import 'package:webdding/utils/helpers.dart';
import 'package:webdding/widgets/task_location.dart';

class WorkScheduleDetailScreen extends StatelessWidget {
  final WorkSchedule workSchedule;

  WorkScheduleDetailScreen({Key? key, required this.workSchedule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Chi tiết lịch làm việc',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 35, 76, 191),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.white),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context); // Quay lại màn hình trước đó
            },
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailSection('Danh sách địa điểm chụp', [
                BuildLocationsList(workSchedule.locations),
              ]),
              _buildDetailSection('Thông Tin Cơ Bản', [
                _buildDetailRow('ID Lịch Làm Việc', workSchedule.id),
                _buildDetailRow('Tên Khách Hàng', workSchedule.customerName),
                _buildDetailRow('Số Điện Thoại', workSchedule.customerPhone),
                _buildDetailRow('Email', workSchedule.customerEmail),
                _buildDetailRow('Ngày Chụp',
                    DateFormat('dd-MM-yyyy').format(workSchedule.shootingDate)),
                _buildDetailRow('Giờ Chụp',
                    '${workSchedule.shootingTime.hour}:${workSchedule.shootingTime.minute}'),
              ]),
              _buildDetailSection('Đội Ngũ', [
                _buildDetailRow(
                    'Người Chụp Ảnh', "${workSchedule.photographer.name} - ${workSchedule.photographer.phoneNumber}"),
                _buildDetailRow(
                    'Người Trang Điểm',"${workSchedule.makeupArtist.name} - ${workSchedule.makeupArtist.phoneNumber}"),
                _buildDetailRow('Người Thiết Kế', "${workSchedule.designer.name} - ${workSchedule.designer.phoneNumber}"),
              ]),
              _buildDetailSection('Chi Phí', [
                _buildDetailRow(
                    'Giá Gói', formatPrice(workSchedule.packagePrice)),
                _buildDetailRow(
                    'Giá Makeup', formatPrice(workSchedule.makeupPrice)),
                _buildDetailRow('Giá Nhà Thiết Kế',
                    formatPrice(workSchedule.designerPrice)),
                _buildDetailRow('Giá Người Chụp Ảnh',
                    formatPrice(workSchedule.photographerPrice)),
              ]),
              _buildDetailSection('Khác', [
                _buildDetailRow('Ghi Chú', workSchedule.notes),
                _buildDetailRow('Trạng Thái', workSchedule.status),
                // _buildDetailRow(
                //     'Ngày Tạo',
                //     DateFormat('yyyy-MM-dd hh:mm')
                //         .format(workSchedule.createdAt.toDate())),
                // _buildDetailRow(
                //     'Ngày Cập Nhật',
                //     DateFormat('yyyy-MM-dd hh:mm')
                //         .format(workSchedule.updatedAt.toDate())),
              ]),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateWorkScheduleScreen(workSchedule: workSchedule),
                    ),
                  );
                },
                child: const Text(
                  'Chỉnh Sửa',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
              // const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () {/* Chức năng xóa */},
              //   style: ElevatedButton.styleFrom(primary: Colors.red),
              //   child: const Text('Xóa'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webdding/models/localtion.dart';

Widget BuildLocationsList(List<Location> locations) {
  if (locations.isEmpty) {
    return SizedBox.shrink(); // Không hiển thị gì nếu danh sách trống
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListView.builder(
        shrinkWrap: true,
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return ListTile(
            title: Text(location.name),
            subtitle: Text(location.address),
            // Các thông tin khác của địa điểm nếu cần
          );
        },
      ),
    ],
  );
}
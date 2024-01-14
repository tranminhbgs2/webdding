import 'package:flutter/material.dart';
import 'package:webdding/models/work_schedule.dart';

class TaskItem extends StatelessWidget {
  // final Task task;
  final WorkSchedule workSchedule;

  const TaskItem({super.key, required this.workSchedule});

  @override
  Widget build(BuildContext context) {
    return // Generated code for this Container Widget...
        Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x33000000),
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                  //   child: Text(
                  //       "Khách hàng: ${workSchedule.customerName} - (${workSchedule.customerPhone})",
                  //       style: const TextStyle(
                  //         fontFamily: 'Inter',
                  //         color: Color(0xFF090F13),
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //       )),
                  // ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: const Color.fromARGB(255, 204, 144, 55),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 4, 8, 4),
                              child: Text(
                                '${workSchedule.shootingTime.hour.toString().padLeft(2, '0')}:${workSchedule.shootingTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color.fromARGB(255, 232, 232, 232),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                            "Khách hàng: ${workSchedule.customerName} - (${workSchedule.customerPhone})",
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF090F13),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: workSchedule.locations.map((location) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color.fromARGB(255, 21, 121, 187),
                              size: 20.0,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${location.name} (${location.address})",
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFF090F13),
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              softWrap: true, // Enable text wrapping
                              overflow: TextOverflow.visible, // Handle overflow
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: Color.fromARGB(255, 21, 121, 187),
                          size: 20.0,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${workSchedule.photographer.name} - ${workSchedule.photographer.phoneNumber}",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF090F13),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_2_outlined,
                          color: Color.fromARGB(255, 21, 121, 187),
                          size: 20.0,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${workSchedule.makeupArtist.name} - ${workSchedule.makeupArtist.phoneNumber}",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF090F13),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.photo_camera_back_outlined,
                          color: Color.fromARGB(255, 21, 121, 187),
                          size: 20.0,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${workSchedule.designer.name} - ${workSchedule.designer.phoneNumber}",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF090F13),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

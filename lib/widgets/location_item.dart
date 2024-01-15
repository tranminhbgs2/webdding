import 'package:flutter/material.dart';
import 'package:webdding/models/localtion.dart';
import 'package:webdding/screens/location/update.dart';

class LocationItem extends StatelessWidget {
  final Location location;

  const LocationItem({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => EmployeeDetailScreen(customer: employee),
            builder: (context) => EditLocation(location: location),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x32000000),
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.blue, size: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                location.name,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Color(0xFF14181B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            location.address,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            location.phone,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             EmployeeDetailScreen(customer: employee),
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: Color(0xFF4B39EF),
                //     onPrimary: Colors.white,
                //     padding: EdgeInsets.zero,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   child: Container(
                //     width: 70,
                //     height: 36,
                //     alignment: Alignment.center,
                //     child: Text(
                //       'Chi tiết',
                //       style: TextStyle(
                //         fontFamily: 'Outfit',
                //         fontSize: 14,
                //         fontWeight: FontWeight.normal,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

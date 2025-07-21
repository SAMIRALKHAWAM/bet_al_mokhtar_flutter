// import 'package:almoktar/blocs/cubit_app/cubit.dart';
// import 'package:almoktar/screens/delivery/AnimatedMarker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import '../../blocs/cubit_app/statues.dart';

// class TrackOrderPage extends StatelessWidget {
//   const TrackOrderPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تتبع الطلب')),
//       body: BlocBuilder<AppCubit, AppSates>(
//         builder: (context, state) {
//           final cubit = AppCubit.get(context);
//           final orderLoc =
//               cubit.currentOrderLocation ??
//               LatLng(31.963158, 35.930359); // مثال: موقع افتراضي (الأردن)

//           return FlutterMap(
//             options: MapOptions(center: orderLoc, zoom: 15),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 subdomains: const ['a', 'b', 'c'],
//               ),
//               MarkerLayer(
//                 markers: [
//                   Marker(
//                     width: 80,
//                     height: 80,
//                     point: orderLoc,
//                     child: AnimatedMarker(
//                       point: orderLoc,
//                       child: const Icon(
//                         Icons.delivery_dining,
//                         size: 40,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // تحديث موقع الطلب كمثال (تحريك المؤشر)
//           final cubit = AppCubit.get(context);

//           // هنا تضع اللوجيك الفعلي لجلب إحداثيات جديدة من API
//           // هذا مجرد مثال تحريك عشوائي
//           final current =
//               cubit.currentOrderLocation ?? LatLng(31.963158, 35.930359);
//           final newLoc = LatLng(
//             current.latitude + 0.0005,
//             current.longitude + 0.0005,
//           );
//           cubit.updateOrderLocation(newLoc);
//         },
//         child: const Icon(Icons.location_on),
//       ),
//     );
//   }
// }





import 'package:almoktar/cubits/Location/location_cubit.dart';
import 'package:almoktar/cubits/Location/location_state.dart';
import 'package:almoktar/screens/delivery/AnimatedMarker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/location_model.dart';


class TrackOrderPage extends StatelessWidget {
  const TrackOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الطلب')),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          LatLng currentLoc = const LatLng(31.963158, 35.930359); // الأردن كافتراضي

          if (state is LocationUpdated) {
            currentLoc = LatLng(state.location.latitude, state.location.longitude);
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: currentLoc,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentLoc,
                    width: 80,
                    height: 80,
                    child:  AnimatedMarker(
                      point: currentLoc,
                      child: const Icon(
                        Icons.delivery_dining,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

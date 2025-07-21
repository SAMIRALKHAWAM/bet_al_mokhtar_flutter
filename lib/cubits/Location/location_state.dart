

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:latlong2/latlong.dart';

import '../../models/location_model.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationUpdated extends LocationState {
  final Location location;

  LocationUpdated(this.location);
}
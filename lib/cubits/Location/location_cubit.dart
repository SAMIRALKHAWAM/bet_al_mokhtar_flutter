

import 'package:almoktar/cubits/Location/location_state.dart';
import 'package:almoktar/models/location_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LocationCubit extends Cubit<LocationState> {
  final IO.Socket socket;

  LocationCubit(this.socket) : super(LocationInitial()) {
    socket.onConnect((_) {
      print('Connected to Socket.IO');
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO');
    });

    socket.on('location_update', (data) {
      final location = Location.fromJson(data);
      emit(LocationUpdated(location));
    });

    socket.connect();
  }

  @override
  Future<void> close() {
    socket.disconnect();
    return super.close();
  }
}
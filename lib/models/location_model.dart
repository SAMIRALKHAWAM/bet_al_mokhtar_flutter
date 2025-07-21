// ignore_for_file: public_member_api_docs, sort_constructors_first
class Location {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  Location({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] * 1000).toInt(),
      ),
    );
  }

  @override
  String toString() => 'Location(latitude: $latitude, longitude: $longitude, timestamp: $timestamp)';
} 
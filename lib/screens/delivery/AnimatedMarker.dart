


import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AnimatedMarker extends StatefulWidget {
  final LatLng point;
  final Widget child;

  const AnimatedMarker({
    super.key,
    required this.point,
    required this.child,
  });

  @override
  State<AnimatedMarker> createState() => _AnimatedMarkerState();
}

class _AnimatedMarkerState extends State<AnimatedMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  LatLng? _previousPoint;
  late Tween<double> _latTween;
  late Tween<double> _lngTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(AnimatedMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.point != widget.point) {
      _previousPoint = oldWidget.point;
      _latTween = Tween<double>(
        begin: _previousPoint!.latitude,
        end: widget.point.latitude,
      );
      _lngTween = Tween<double>(
        begin: _previousPoint!.longitude,
        end: widget.point.longitude,
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LatLng _getInterpolatedPoint() {
    final lat = _latTween.evaluate(_animation);
    final lng = _lngTween.evaluate(_animation);
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    if (_previousPoint == null) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final interpolatedPoint = _getInterpolatedPoint();

        // بدلاً من تحريك child داخل الـ widget، نعيد بناء Marker مع إحداثيات متحركة
        return MarkerWidget(
          point: interpolatedPoint,
          child: widget.child,
        );
      },
    );
  }
}

// لأن flutter_map لا يقبل Marker widget مباشرة، عليك إعادة بناء Marker في مكان آخر.
// MarkerWidget هو مجرد تمثيل تخيلي، تحتاج تستخدمه داخل flutter_map Marker.builder.

class MarkerWidget extends StatelessWidget {
  final LatLng point;
  final Widget child;

  const MarkerWidget({required this.point, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // هذا widget مجرد placeholder. في الحقيقة Marker يتم إضافته داخل flutter_map.
    return child;
  }
}

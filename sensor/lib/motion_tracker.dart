import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionTracker extends StatefulWidget {
  const MotionTracker({super.key});

  @override
  State<MotionTracker> createState() => _MotionTrackerState();
}

class _MotionTrackerState extends State<MotionTracker> {
  int _shakeCount = 0;
  static const double _shakeThreshold = 15.0; // Ngưỡng lắc
  DateTime _lastShakeTime = DateTime.now();
  Color _bgColor = Colors.blueGrey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(title: const Text("Motion Tracker")),
      body: StreamBuilder<UserAccelerometerEvent>(
        stream: userAccelerometerEventStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: Text("Đang chờ cảm biến..."));

          final event = snapshot.data!;
          // Tính tổng gia tốc 3 chiều
          double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

          if (acceleration > _shakeThreshold) {
            final now = DateTime.now();
            // Debounce 500ms để tránh đếm trùng
            if (now.difference(_lastShakeTime).inMilliseconds > 500) {
              _lastShakeTime = now;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _shakeCount++;
                    _bgColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                  });
                }
              });
            }
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.vibration, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                Text("SHAKE COUNT: $_shakeCount", 
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("Gia tốc: ${acceleration.toStringAsFixed(2)} m/s²", 
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          );
        },
      ),
    );
  }
}
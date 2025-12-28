import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart'; // <-- Đổi import thư viện mới

class LightMeter extends StatefulWidget {
  const LightMeter({super.key});

  @override
  State<LightMeter> createState() => _LightMeterState();
}

class _LightMeterState extends State<LightMeter> {
  int _luxValue = 0;
  StreamSubscription? _subscription;
  Light? _light;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _light = Light();
    try {
      // Thư viện 'light' dùng lightSensorStream thay vì luxStream
      _subscription = _light?.lightSensorStream.listen((lux) {
        if (mounted) {
          setState(() {
            _luxValue = lux;
          });
        }
      }, onError: (error) {
        print("Lỗi cảm biến ánh sáng: $error");
      });
    } catch (e) {
      print("Thiết bị không hỗ trợ hoặc lỗi: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Logic phân loại độ sáng giữ nguyên như bài học
  String getLightStatus(int lux) {
    if (lux < 10) return "TỐI OM (Phòng kín)";
    if (lux < 500) return "SÁNG VỪA (Trong nhà)";
    return "RẤT SÁNG (Ngoài trời)";
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = _luxValue < 50;
    return Scaffold(
      backgroundColor: isDark ? Colors.black87 : Colors.white,
      appBar: AppBar(title: const Text("Light Meter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb, size: 100, color: isDark ? Colors.grey : Colors.orangeAccent),
            const SizedBox(height: 20),
            Text("$_luxValue LUX",
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            Text(getLightStatus(_luxValue),
                style: TextStyle(fontSize: 24, color: isDark ? Colors.white70 : Colors.black54)),
          ],
        ),
      ),
    );
  }
}
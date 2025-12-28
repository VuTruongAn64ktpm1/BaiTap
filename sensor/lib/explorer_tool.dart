import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class ExplorerTool extends StatefulWidget {
  const ExplorerTool({super.key});

  @override
  State<ExplorerTool> createState() => _ExplorerToolState();
}

class _ExplorerToolState extends State<ExplorerTool> {
  String _locationMessage = "Đang lấy vị trí...";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationMessage = "Hãy bật GPS trên điện thoại!");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationMessage = "Quyền vị trí bị từ chối.");
        return;
      }
    }

    // Lấy vị trí chính xác cao
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        _locationMessage =
            "Lat: ${position.latitude}\nLong: ${position.longitude}\nAlt: ${position.altitude.toStringAsFixed(1)}m";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Explorer Tool"), backgroundColor: Colors.grey[900]),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.blueGrey[900],
            child: Text(_locationMessage,
                style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontFamily: 'monospace'),
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: StreamBuilder<MagnetometerEvent>(
              stream: magnetometerEventStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final event = snapshot.data!;
                double heading = atan2(event.y, event.x); // Radian
                double headingDegrees = (heading * 180 / pi);
                if (headingDegrees < 0) headingDegrees += 360; // Chuyển sang độ dương

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${headingDegrees.toStringAsFixed(0)}°",
                          style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
                      const Text("HƯỚNG BẮC", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),
                      Transform.rotate(
                        angle: -heading, // Xoay kim la bàn ngược chiều xoay điện thoại
                        child: const Icon(Icons.navigation, size: 150, color: Colors.redAccent),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
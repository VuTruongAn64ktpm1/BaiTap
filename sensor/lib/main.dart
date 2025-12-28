import 'package:flutter/material.dart';
import 'motion_tracker.dart';
import 'explorer_tool.dart';
import 'light_meter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sensor Homework',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bài tập lớn Chương 20: Cảm biến")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(context, "Bài 1: Motion Tracker (Lắc tay)", const MotionTracker()),
            _buildNavButton(context, "Bài 2: Explorer Tool (GPS & La bàn)", const ExplorerTool()),
            _buildNavButton(context, "Bài 3: Light Meter (Đo sáng)", const LightMeter()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Text(text),
      ),
    );
  }
}
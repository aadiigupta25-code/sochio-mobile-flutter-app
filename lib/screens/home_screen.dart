import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isConnected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    final connected = await ApiService.testConnection();
    setState(() {
      _isConnected = connected;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sochio'),
        backgroundColor: const Color(0xFFB93160),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.error,
                  size: 100,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 20),
                Text(
                  _isConnected 
                      ? 'Connected to Admin Panel' 
                      : 'Connection Failed',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isConnected 
                      ? 'Backend is running properly' 
                      : 'Check backend server status',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _checkConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB93160),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Test Connection'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  key: const Key('video_nav_button'),
                  onPressed: () => Get.to(() => const VideoScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Watch Videos'),
                ),
              ],
            ),
    );
  }
}
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Short Text', style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),
          Text(
            'This is a longer piece of text that wraps to multiple lines.',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          Text(
            'LARGE TEXT',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton(onPressed: null, child: Text('Small Button')),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: null,
              child: Text('Full Width Button'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _RegisterHomeScreenState();
}

class _RegisterHomeScreenState extends State<HomeScreen> {
  final List<String> items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HeroCtrl'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final title = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.videocam)),
              title: Text(title),
              subtitle: const Text('Tap to connect'),
              onTap: () {
                // handle tap
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera_search');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

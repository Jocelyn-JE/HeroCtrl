import 'package:flutter/material.dart';
import 'package:heroctrl/models/gopro_registration.dart';
import 'package:heroctrl/services/gopro_prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _RegisterHomeScreenState();
}

class _RegisterHomeScreenState extends State<HomeScreen> {
  late Future<List<GoProRegistration>> registeredGopros;

  @override
  void initState() {
    super.initState();
    registeredGopros = GoProPrefs.getAll();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HeroCtrl'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.pushNamed(context, '/settings');
              setState(() {
                registeredGopros = GoProPrefs.getAll();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<GoProRegistration>>(
        future: registeredGopros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            return const Center(child: Text('No registered GoPros'));
          }
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final title = data[index].ssid;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.videocam)),
                  title: Text(title),
                  subtitle: const Text('Tap to connect'),
                  onTap: () {
                    // handle tap
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/camera_search');
          setState(() {
            registeredGopros = GoProPrefs.getAll();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

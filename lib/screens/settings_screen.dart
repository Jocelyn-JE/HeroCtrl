import 'package:flutter/material.dart';
import 'package:heroctrl/services/gopro_prefs.dart';
import 'package:heroctrl/widgets/red_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final navigatorState = Navigator.of(context);
                      return AlertDialog(
                        title: const Text('Forget all cameras'),
                        content: const Text(
                          'Are you sure you want to forget all cameras?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              navigatorState.pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          RedButton(
                            onPressed: () async {
                              await GoProPrefs.clearAll();
                              navigatorState.pop();
                            },
                            child: const Text('Forget'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Forget all cameras'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

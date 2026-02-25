import 'package:flutter/material.dart';
import 'package:heroctrl/models/gopro_registration.dart';

class CameraListItem extends StatelessWidget {
  final GoProRegistration camera;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CameraListItem({
    super.key,
    required this.camera,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.videocam)),
        title: Text(camera.ssid),
        trailing: const Icon(Icons.chevron_right),
        subtitle: Text(camera.cameraModel),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}

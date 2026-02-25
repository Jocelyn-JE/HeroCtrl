import 'package:flutter/material.dart';
import 'package:heroctrl/models/gopro_registration.dart';
import 'camera_list_item.dart';
import 'empty_cameras_state.dart';
import 'error_state.dart';
import 'loading_state.dart';

class CameraListView extends StatelessWidget {
  final Future<List<GoProRegistration>> camerasFuture;
  final Function(GoProRegistration)? onCameraTap;
  final Function(GoProRegistration)? onCameraLongPress;

  const CameraListView({
    super.key,
    required this.camerasFuture,
    this.onCameraTap,
    this.onCameraLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return FutureBuilder<List<GoProRegistration>>(
      future: camerasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingState();
        }
        if (snapshot.hasError) {
          return ErrorState(error: snapshot.error.toString());
        }
        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return const EmptyCamerasState();
        }
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final camera = data[index];
            return CameraListItem(
              camera: camera,
              onTap: onCameraTap != null ? () => onCameraTap!(camera) : null,
              onLongPress: onCameraLongPress != null
                  ? () => onCameraLongPress!(camera)
                  : null,
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/resolution_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/fps_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/fov_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/fix_stream_button.dart';

class HorizontalLayout extends StatelessWidget {
  final Widget previewArea;
  final CameraState? cameraState;
  final String password;
  final Future<void> Function(VideoResolution) onResolutionChanged;
  final Future<void> Function(FPS) onFpsChanged;
  final Future<void> Function(FOV) onFovChanged;

  const HorizontalLayout({
    super.key,
    required this.previewArea,
    required this.cameraState,
    required this.password,
    required this.onResolutionChanged,
    required this.onFpsChanged,
    required this.onFovChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: previewArea),
        if (cameraState != null && !cameraState!.status.shutterStatus)
          SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ResolutionSelector(
                    cameraState: cameraState!,
                    password: password,
                    onResolutionChanged: onResolutionChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FPSSelector(
                    cameraState: cameraState!,
                    password: password,
                    onFpsChanged: onFpsChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FOVSelector(
                    cameraState: cameraState!,
                    password: password,
                    onFovChanged: onFovChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FixStreamButton(camPassword: password),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

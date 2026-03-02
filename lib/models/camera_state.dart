import 'package:heroctrl/models/camera_status.dart';

class CameraState {
  CameraStatus status;
  bool isCameraOn = false;
  bool isPreviewOn = false;
  int batteryPercent;

  CameraState(this.status) : batteryPercent = status.batteryLevel * 25;
}

import 'package:heroctrl/models/camera_serial_and_mac.dart';
import 'package:heroctrl/models/camera_version.dart';
import 'package:http/http.dart' as http;
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/models/camera_status.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';

class GoProApiService {
  static const _camera = 'camera';
  static const _bacpac = 'bacpac';

  static Future<void> stopShutter(String password) async {
    await _postApi(_camera, GoProEndpoints.shutter, password, Shutter.stop);
  }

  static Future<void> startShutter(String password) async {
    await _postApi(_camera, GoProEndpoints.shutter, password, Shutter.start);
  }

  static Future<void> turnOffCamera(String password) async {
    await _postApi(_bacpac, GoProEndpoints.power, password, Power.off);
  }

  static Future<void> turnOnCamera(String password) async {
    await _postApi(_bacpac, GoProEndpoints.power, password, Power.on);
  }

  static Future<void> startVideoPreview(String password) async {
    await _postApi(
      _bacpac,
      GoProEndpoints.videoPreview,
      password,
      VideoPreview.on,
    );
  }

  static Future<void> stopVideoPreview(String password) async {
    await _postApi(
      _bacpac,
      GoProEndpoints.videoPreview,
      password,
      VideoPreview.off,
    );
  }

  static Future<bool> isVideoPreviewOn(String password) async {
    final response = await _getApi(
      _bacpac,
      GoProEndpoints.videoPreview,
      password,
    );
    return response.bodyBytes[1] == 2;
  }

  static Future<bool> cameraPowerStatus(String password) async {
    final response = await _getApi(_bacpac, GoProEndpoints.power, password);
    return response.bodyBytes[1] == 1;
  }

  /// Waits until the camera is powered on, polling every 1 second
  /// Throws Exception if timeout (15 seconds) is reached
  static Future<void> waitUntilCameraOn(
    String password, {
    Duration pollInterval = const Duration(seconds: 1),
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final startTime = DateTime.now();
    while (true) {
      try {
        final isOn = await cameraPowerStatus(password);
        if (isOn) {
          AppLogger.info('Camera is now powered on');
          await Future.delayed(const Duration(milliseconds: 200));
          return;
        }
      } catch (e) {
        // Ignore errors during polling, camera might not be ready yet
        AppLogger.info('Waiting for camera to power on... ($e)');
      }

      if (DateTime.now().difference(startTime) > timeout) {
        throw Exception('Timeout waiting for camera to power on');
      }

      await Future.delayed(pollInterval);
    }
  }

  /// Waits until the video preview is enabled, polling every 1 second
  /// Throws Exception if timeout (15 seconds) is reached
  static Future<void> waitUntilPreviewOn(
    String password, {
    Duration pollInterval = const Duration(seconds: 1),
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final startTime = DateTime.now();
    while (true) {
      try {
        final isOn = await isVideoPreviewOn(password);
        if (isOn) {
          AppLogger.info('Video preview is now enabled');
          await Future.delayed(const Duration(seconds: 3));
          return;
        }
      } catch (e) {
        // Ignore errors during polling, preview might not be ready yet
        AppLogger.info('Waiting for video preview to enable... ($e)');
      }

      if (DateTime.now().difference(startTime) > timeout) {
        throw Exception('Timeout waiting for video preview to enable');
      }

      await Future.delayed(pollInterval);
    }
  }

  static Future<CameraStatus> getStatus(String password) async {
    final response = await _getApi(_camera, GoProEndpoints.status, password);
    final bytes = response.bodyBytes;
    AppLogger.info('GoPro Status: ${bytes.length} bytes');
    return CameraStatus(bytes);
  }

  static Future<CameraVersion> getVersion(String password) async {
    final response = await _getApi(
      _camera,
      GoProEndpoints.cameraVersion,
      password,
    );
    final bytes = response.bodyBytes;
    AppLogger.info('GoPro Version: ${bytes.length} bytes');
    return CameraVersion(bytes);
  }

  static Future<CameraSerialAndMac> getSerialAndMacAddress(
    String password,
  ) async {
    final response = await _getApi(
      _bacpac,
      GoProEndpoints.serialNumber,
      password,
    );
    final bytes = response.bodyBytes;
    AppLogger.info('GoPro Serial and MAC: ${bytes.length} bytes');
    return CameraSerialAndMac(bytes);
  }

  static Future<int> getBatteryLevel(String password) async {
    final response = await _getApi(
      _bacpac,
      GoProEndpoints.batteryLevel,
      password,
    );
    final bytes = response.bodyBytes;
    AppLogger.info('GoPro Battery Level: ${bytes[1]}%');
    if (bytes.length != 2) {
      throw Exception('Invalid response for battery level: ${response.body}');
    }
    return bytes[1];
  }

  static Future<http.Response> _getApi(
    String device,
    String command,
    String? password,
  ) async {
    if (device != _camera && device != _bacpac) {
      throw Exception('_getApi: Invalid device "$device"');
    }

    String path = '${GoProEndpoints.baseUrl}/$device/${command.toLowerCase()}';
    if (password != null) path += '?t=$password';
    final response = await http.get(Uri.parse(path));
    if (response.statusCode != 200 || response.bodyBytes[0] != 0) {
      throw Exception(
        '_getApi: Failed to send "$path" to GoPro\n Response: ${response.body} (hex: ${response.bodyBytes.toString()})',
      );
    }
    return response;
  }

  static Future<http.Response> _postApi(
    String device,
    String command,
    String? password,
    String? option,
  ) async {
    if (device != _camera && device != _bacpac) {
      throw Exception('_postApi: Invalid device "$device"');
    }

    String path = '${GoProEndpoints.baseUrl}/$device/${command.toUpperCase()}';
    if (password != null) path += '?t=$password';
    if (option != null) path += '${password != null ? '&' : '?'}p=%$option';
    final response = await http.get(Uri.parse(path));
    if (response.statusCode != 200 || response.bodyBytes[0] != 0) {
      throw Exception(
        '_postApi: Failed to send "$path" to GoPro\n Response: ${response.body} (hex: ${response.bodyBytes.toString()})',
      );
    }
    return response;
  }
}

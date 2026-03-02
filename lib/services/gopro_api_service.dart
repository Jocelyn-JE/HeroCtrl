import 'dart:async';
import 'package:heroctrl/models/camera_serial_and_mac.dart';
import 'package:heroctrl/models/camera_version.dart';
import 'package:heroctrl/models/camera_wifi_info.dart';
import 'package:http/http.dart' as http;
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/models/camera_status.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';

class GoProApiService {
  static const _camera = 'camera';
  static const _bacpac = 'bacpac';

  // Serialises all HTTP requests so the camera never receives overlapping calls.
  static Future<void> _lock = Future.value();

  static Future<T> _withLock<T>(Future<T> Function() fn) async {
    final previous = _lock;
    final completer = Completer<void>();
    _lock = completer.future;
    try {
      await previous;
      return await fn();
    } finally {
      completer.complete();
    }
  }

  static Future<void> stopShutter(String password) async {
    await _postApi(
      _camera,
      GoProEndpoints.shutter,
      password,
      Shutter.stop.value,
    );
  }

  static Future<void> startShutter(String password) async {
    await _postApi(
      _camera,
      GoProEndpoints.shutter,
      password,
      Shutter.start.value,
    );
  }

  static Future<void> turnOffCamera(String password) async {
    await _postApi(_bacpac, GoProEndpoints.power, password, Power.off.value);
  }

  static Future<void> turnOnCamera(String password) async {
    await _postApi(_bacpac, GoProEndpoints.power, password, Power.on.value);
  }

  static Future<void> startVideoPreview(String password) async {
    await _postApi(
      _bacpac,
      GoProEndpoints.videoPreview,
      password,
      VideoPreview.on.value,
    );
  }

  static Future<void> stopVideoPreview(String password) async {
    await _postApi(
      _bacpac,
      GoProEndpoints.videoPreview,
      password,
      VideoPreview.off.value,
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
          await Future.delayed(const Duration(seconds: 2));
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

  static Future<CameraWifiInfo> getCameraWifiInfo(String password) async {
    final response = await _getApi(_bacpac, GoProEndpoints.wifiInfo, password);
    final bytes = response.bodyBytes;
    AppLogger.info('GoPro WiFi Info: ${bytes.length} bytes');
    return CameraWifiInfo(bytes);
  }

  static Future<void> setLeds(String password, LED ledOption) async {
    await _postApi(_camera, GoProEndpoints.leds, password, ledOption.value);
  }

  static Future<LED> getLeds(String password) async {
    final response = await _getApi(_camera, GoProEndpoints.leds, password);
    final value = response.bodyBytes[1];
    switch (value) {
      case 0:
        return LED.off;
      case 1:
        return LED.twoLeds;
      case 2:
        return LED.fourLeds;
      default:
        return LED.fourLeds;
    }
  }

  static Future<void> setVolume(String password, Volume volumeOption) async {
    await _postApi(
      _camera,
      GoProEndpoints.volume,
      password,
      volumeOption.value,
    );
  }

  static Future<Volume> getVolume(String password) async {
    final response = await _getApi(_camera, GoProEndpoints.volume, password);
    final value = response.bodyBytes[1];
    switch (value) {
      case 0:
        return Volume.mute;
      case 1:
        return Volume.percent70;
      case 2:
        return Volume.percent100;
      default:
        return Volume.percent100;
    }
  }

  static Future<void> setOrientation(String password, bool upsideDown) async {
    await _postApi(
      _camera,
      GoProEndpoints.orientation,
      password,
      upsideDown ? Orientation.down.value : Orientation.up.value,
    );
  }

  static Future<bool> isUpsideDown(String password) async {
    final response = await _getApi(
      _camera,
      GoProEndpoints.orientation,
      password,
    );
    final value = response.bodyBytes[1];
    return value == 1;
  }

  static Future<void> setTime(String password, DateTime time) async {
    String h(int v) => v.toRadixString(16).padLeft(2, '0');
    final formattedTime =
        '${h(time.year % 100)}%${h(time.month)}%${h(time.day)}%${h(time.hour)}%${h(time.minute)}%${h(time.second)}';
    await _postApi(
      _camera,
      GoProEndpoints.timeAndDate,
      password,
      formattedTime,
    );
  }

  static Future<DateTime> getTime(String password) async {
    final response = await _getApi(
      _camera,
      GoProEndpoints.timeAndDate,
      password,
    );
    final bytes = response.bodyBytes;
    if (bytes.length != 7) {
      throw Exception('Invalid response for time: ${response.body}');
    }
    final year = 2000 + bytes[1];
    final month = bytes[2];
    final day = bytes[3];
    final hour = bytes[4];
    final minute = bytes[5];
    final second = bytes[6];
    return DateTime(year, month, day, hour, minute, second);
  }

  static Future<void> setVideoMode(
    String password,
    VideoStandard modeOption,
  ) async {
    await _postApi(
      _camera,
      GoProEndpoints.videoMode,
      password,
      modeOption.value,
    );
  }

  static Future<VideoStandard> getVideoMode(String password) async {
    final response = await _getApi(_camera, GoProEndpoints.videoMode, password);
    final value = response.bodyBytes[1];
    switch (value) {
      case 0:
        return VideoStandard.ntsc;
      case 1:
        return VideoStandard.pal;
      default:
        return VideoStandard.ntsc;
    }
  }

  static Future<void> setDefaultMode(
    String password,
    DefaultCameraMode modeOption,
  ) async {
    await _postApi(
      _camera,
      GoProEndpoints.defaultCameraMode,
      password,
      modeOption.value,
    );
  }

  static Future<DefaultCameraMode> getDefaultMode(String password) async {
    final response = await _getApi(
      _camera,
      GoProEndpoints.defaultCameraMode,
      password,
    );
    final value = response.bodyBytes[1];
    switch (value) {
      case 0:
        return DefaultCameraMode.videoMode;
      case 1:
        return DefaultCameraMode.photoMode;
      case 2:
        return DefaultCameraMode.burstMode;
      case 3:
        return DefaultCameraMode.timeLapseMode;
      default:
        return DefaultCameraMode.videoMode;
    }
  }

  static Future<int> getBatteryLevel(String password) async {
    final response = await _getApi(
      _camera,
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

  static Future<void> setLocateCamera(String password, bool on) async {
    await _postApi(
      _camera,
      GoProEndpoints.locate,
      password,
      on ? Locate.on.value : Locate.off.value,
    );
  }

  static Future<VideoResolution> getVideoResolution(String password) async {
    final response = await _getApi(
      _camera,
      GoProEndpoints.videoResolution,
      password,
    );
    final value = response.bodyBytes[1];
    try {
      return VideoResolution.all.firstWhere((res) => res.value == value);
    } catch (e) {
      AppLogger.error('Error parsing video resolution', e);
      return VideoResolution.wvga240fps;
    }
  }

  static Future<void> setVideoResolution(
    String password,
    VideoResolution resolutionOption,
  ) async {
    await _postApi(
      _camera,
      GoProEndpoints.videoResolution,
      password,
      resolutionOption.value,
    );
  }

  static Future<void> setFPS(String password, FPS fpsOption) async {
    await _postApi(_camera, GoProEndpoints.fps, password, fpsOption.value);
  }

  static Future<http.Response> _getApi(
    String device,
    String command,
    String? password,
  ) => _withLock(() async {
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
  });

  static Future<http.Response> _postApi(
    String device,
    String command,
    String? password,
    dynamic option,
  ) => _withLock(() async {
    if (device != _camera && device != _bacpac) {
      throw Exception('_postApi: Invalid device "$device"');
    }

    String path = '${GoProEndpoints.baseUrl}/$device/${command.toUpperCase()}';
    if (password != null) path += '?t=$password';
    if (option != null) {
      final optionStr = (option is int) ? toHex(option) : option.toString();
      path += '${password != null ? '&' : '?'}p=%$optionStr';
    }
    final response = await http.get(Uri.parse(path));
    if (response.statusCode != 200 || response.bodyBytes[0] != 0) {
      throw Exception(
        '_postApi: Failed to send "$path" to GoPro\n Response: ${response.body} (hex: ${response.bodyBytes.toString()})',
      );
    }
    return response;
  });
}

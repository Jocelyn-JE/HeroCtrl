import 'package:http/http.dart' as http;
import 'package:heroctrl/core/utils/logger.dart';
import 'package:heroctrl/models/camera_status.dart';
import 'package:heroctrl/core/constants/gopro_endpoints.dart';

class GoProApiService {
  static final GoProApiService _instance = GoProApiService._internal();
  static const _camera = 0;
  static const _bacpac = 1;
  static const devices = ['camera', 'bacpac'];

  factory GoProApiService() => _instance;

  GoProApiService._internal();

  Future<void> turnOffCamera(String password) async {
    await _postApi(_bacpac, GoProEndpoints.power, password, Power.off);
  }

  Future<void> turnOnCamera(String password) async {
    await _postApi(_bacpac, GoProEndpoints.power, password, Power.on);
  }

  Future<bool> cameraTurnedOn(String password) async {
    final response = await _getApi(_bacpac, GoProEndpoints.power, password);
    return response.bodyBytes[1] == 1;
  }

  Future<CameraStatus> getStatus(String password) async {
    final response = await _getApi(_camera, GoProEndpoints.status, password);
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      AppLogger.info('GoPro Status: ${bytes.length} bytes');
      return CameraStatus(bytes);
    } else {
      AppLogger.error('Failed to get GoPro status. Response: ${response.body}');
      throw Exception('Failed to get GoPro status');
    }
  }

  Future<http.Response> _getApi(
    int device,
    String command,
    String? password,
  ) async {
    if (device != _camera && device != _bacpac) {
      throw Exception('Invalid device: $device');
    }

    String path =
        '${GoProEndpoints.baseUrl}/${devices[device]}/${command.toLowerCase()}';
    if (password != null) path += '?t=$password';
    final response = await http.get(Uri.parse(path));
    if (response.statusCode != 200 || response.bodyBytes[0] != 0) {
      AppLogger.error(
        'Failed to send command to GoPro: $path\n Response: ${response.bodyBytes.toString()}',
      );
      throw Exception('Command failed: $path');
    }
    return response;
  }

  Future<http.Response> _postApi(
    int device,
    String command,
    String? password,
    String? option,
  ) async {
    if (device != _camera && device != _bacpac) {
      throw Exception('Invalid device: $device');
    }

    String path =
        '${GoProEndpoints.baseUrl}/${devices[device]}/${command.toUpperCase()}';
    if (password != null) path += '?t=$password';
    if (option != null) path += '${password != null ? '&' : '?'}p=%$option';
    final response = await http.get(Uri.parse(path));
    if (response.statusCode != 200 || response.bodyBytes[0] != 0) {
      AppLogger.error(
        'Failed to send command to GoPro: $path\n Response: ${response.body}',
      );
      throw Exception('Command failed: $path');
    }
    return response;
  }
}

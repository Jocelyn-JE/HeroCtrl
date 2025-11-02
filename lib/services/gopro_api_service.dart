import 'package:http/http.dart' as http;
import 'package:heroctrl/core/utils/logger.dart';
import 'package:heroctrl/models/camera_status.dart';
import 'package:heroctrl/core/constants/gopro_endpoints.dart';

class GoProApiService {
  static final GoProApiService _instance = GoProApiService._internal();
  static const _camera = 'camera';
  static const _bacpac = 'bacpac';

  factory GoProApiService() => _instance;

  GoProApiService._internal();

  Future<void> turnOffCamera(String password) async {
    await _postApi(_bacpac, GoProEndpoints.power, password, Power.off);
  }

  Future<void> turnOnCamera(String password) async {
    await _postApi(_bacpac, GoProEndpoints.power, password, Power.on);
  }

  Future<bool> cameraPowerStatus(String password) async {
    final response = await _getApi(_bacpac, GoProEndpoints.power, password);
    return response.bodyBytes[1] == 1;
  }

  Future<CameraStatus> getStatus(String password) async {
    final response = await _getApi(_camera, GoProEndpoints.status, password);
    final bytes = response.bodyBytes;
    AppLogger.info('GoPro Status: ${bytes.length} bytes');
    return CameraStatus(bytes);
  }

  Future<http.Response> _getApi(
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

  Future<http.Response> _postApi(
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

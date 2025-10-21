import 'package:http/http.dart' as http;
import 'package:heroctrl/core/utils/logger.dart';
import 'package:heroctrl/models/camera_status.dart';
import 'package:heroctrl/core/constants/gopro_endpoints.dart';

class GoProApiService {
  GoProApiService();

  Future<CameraStatus> getStatus() async {
    final response = await http.get(Uri.parse(GoProEndpoints.status));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      AppLogger.info('GoPro Status: ${bytes.length} bytes');
      return CameraStatus(bytes);
    } else {
      AppLogger.error('Failed to get GoPro status. Response: ${response.body}');
      throw Exception('Failed to get GoPro status');
    }
  }

  Future<void> _sendCommand(String path) async {
    final response = await http.get(
      Uri.parse('${GoProEndpoints.baseUrl}$path'),
    );
    if (response.statusCode != 200) {
      AppLogger.error(
        'Failed to send command to GoPro: $path\n Response: ${response.body}',
      );
      throw Exception('Command failed: $path');
    }
  }
}

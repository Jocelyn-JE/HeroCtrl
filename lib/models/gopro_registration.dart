class GoProRegistration {
  // The WiFi SSID of the camera (e.g. "GoPro-12345678")
  final String ssid;
  // The BSSID (MAC address) of the camera's wi-fi network
  final String bssid;
  // The camera's serial number (e.g. "12345678")
  final String serialNumber;
  // The camera model (e.g. "HERO9 Black")
  final String cameraModel;
  // The camera's firmware version (e.g. "1.60")
  final String firmwareVersion;
  // The camera's MAC address (e.g. "D8:96:85:12:34:56")
  final String macAddress;
  // The password for the camera's WiFi network (e.g. "12345678")
  final String password;

  GoProRegistration({
    required this.ssid,
    required this.bssid,
    required this.serialNumber,
    required this.cameraModel,
    required this.firmwareVersion,
    required this.macAddress,
    required this.password,
  });

  factory GoProRegistration.fromJson(Map<String, dynamic> json) {
    return GoProRegistration(
      ssid: json['ssid'],
      bssid: json['bssid'],
      serialNumber: json['serial_number'],
      cameraModel: json['camera_model'],
      firmwareVersion: json['firmware_version'],
      macAddress: json['mac_address'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'bssid': bssid,
      'serial_number': serialNumber,
      'camera_model': cameraModel,
      'firmware_version': firmwareVersion,
      'mac_address': macAddress,
      'password': password,
    };
  }
}

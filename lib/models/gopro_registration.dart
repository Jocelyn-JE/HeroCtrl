class GoProRegistration {
  final String ssid;
  final String bssid;
  final String serialNumber;
  final String cameraModel;
  final String firmwareVersion;
  final String macAddress;
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

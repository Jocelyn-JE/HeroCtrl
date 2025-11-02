class GoProRegistration {
  final String ssid;
  final String bssid;
  final String serialNumber;
  final String macAddress;

  GoProRegistration({
    required this.ssid,
    required this.bssid,
    required this.serialNumber,
    required this.macAddress,
  });

  factory GoProRegistration.fromJson(Map<String, dynamic> json) {
    return GoProRegistration(
      ssid: json['ssid'],
      bssid: json['bssid'],
      serialNumber: json['serial_number'],
      macAddress: json['mac_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'bssid': bssid,
      'serial_number': serialNumber,
      'mac_address': macAddress,
    };
  }
}

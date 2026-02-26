import 'package:heroctrl/services/gopro_registry.dart';

/*
** OUI standard license header for GoPro, Inc.
** D8:96:85 2011-08-05 HERO2 / HERO3 / HERO3+
** D4:D9:19 2013-09-12 HERO4 / HERO4 Silver
** F4:DD:9E 2014-04-22 HERO4 Black / HERO5
** 04:41:69 2015-11-17 HERO5 Session ou Black
** D4:32:60 2018-07-28 HERO6 / HERO7
** 24:74:F7 2019-08-07 HERO7 / HERO8
** 04:57:47 2022-05-07 HERO9 / HERO10
** AC:04:AA 2024-09-04 HERO10 / HERO11 or newer
** I have NO idea if this is true, to be honest I just asked ChatGPT
** about the OUI prefixes with their release dates and it gave me these.
** So take this with a grain of salt.
*/

/// Utility class for validating GoPro devices
class GoProValidator {
  /// Known GoPro OUI (Organizationally Unique Identifier) prefixes
  /// These are the first 3 bytes of the MAC address that identify the manufacturer
  static const List<String> _goProPrefixes = [
    'D8:96:85', // HERO2 / HERO3 / HERO3+
    'D4:D9:19', // HERO4 / HERO4 Silver
    'F4:DD:9E', // HERO4 Black / HERO5
    '04:41:69', // HERO5 Session or Black
    'D4:32:60', // HERO6 / HERO7
    '24:74:F7', // HERO7 / HERO8
    '04:57:47', // HERO9 / HERO10
    'AC:04:AA', // HERO10 / HERO11 or newer
  ];

  /*
  ** Check if a given BSSID belongs to a GoPro device based on known OUI prefixes.
  ** Since the app is made with only a GoPro Hero 3+ available to test, this
  ** function may need to be updated in the future if we need to add support for
  ** newer GoPro models with different OUI prefixes.
  */
  static bool isGoPro(String bssid) {
    const prefixes = ['D8:96:85'];
    return prefixes.any((p) => bssid.toUpperCase().startsWith(p));
  }

  /// Check if a camera with the given BSSID is already registered
  static Future<bool> isRegistered(String bssid) async {
    return await GoProPrefs.findByBssid(bssid) != null;
  }

  /// Get all known GoPro prefixes (for reference or future expansion)
  static List<String> get allKnownPrefixes => _goProPrefixes;
}

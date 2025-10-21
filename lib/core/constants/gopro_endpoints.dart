class GoProEndpoints {
  static const String baseUrl = 'http://10.5.5.9/';
  static const String status = '$baseUrl/camera/sx';
  static const String firmwareVersion = '$baseUrl/camera/cv'; // Camera Version
  static const String startRecording = '$baseUrl/start';
  static const String stopRecording = '$baseUrl/stop';
}

// Unsure if this works, nothing happened during testing
class CameraModes {
  static const String videoMode = '00';
  static const String photoMode = '01';
  static const String burstMode = '02';
  static const String timeLapseMode = '03';
  static const String timerMode = '04'; // Hero 2
  static const String hdmiMode = '05';
  static const cameraModesStrings = {
    CameraModes.videoMode: 'Video',
    CameraModes.photoMode: 'Photo',
    CameraModes.burstMode: 'Burst',
    CameraModes.timeLapseMode: 'Time Lapse',
    CameraModes.timerMode: 'Timer',
    CameraModes.hdmiMode: 'HDMI Output',
  };
}

class Orientations {
  static const String landscape = '00';
  static const String portrait = '01';
  static const orientationsStrings = {
    Orientations.landscape: 'Landscape',
    Orientations.portrait: 'Portrait',
  };
}

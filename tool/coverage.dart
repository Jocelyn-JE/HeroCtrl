import 'dart:io';

const _supportedArgs = {'--no-open', '--help', '-h'};

void _printUsage() {
  stdout.writeln('''
HeroCtrl coverage runner

Usage:
  dart run tool/coverage.dart [--no-open]

Options:
  --no-open   Generate coverage HTML but do not open the browser
  --help, -h  Show this help
''');
}

Future<int> _runCommand(
  String executable,
  List<String> args, {
  bool runInShell = false,
}) async {
  try {
    final process = await Process.start(
      executable,
      args,
      runInShell: runInShell,
      mode: ProcessStartMode.inheritStdio,
    );
    return process.exitCode;
  } on ProcessException catch (error) {
    stderr.writeln('Failed to start command: $executable ${args.join(' ')}');
    stderr.writeln(error.message);
    return 127;
  }
}

Future<int> _openInBrowser(String filePath) {
  if (Platform.isLinux) {
    return _runCommand('xdg-open', [filePath], runInShell: true);
  }
  if (Platform.isMacOS) {
    return _runCommand('open', [filePath], runInShell: true);
  }
  if (Platform.isWindows) {
    return _runCommand('cmd', ['/c', 'start', '', filePath], runInShell: true);
  }

  stderr.writeln(
    'Automatic browser opening is not supported on this platform.',
  );
  return Future.value(1);
}

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printUsage();
    return;
  }

  final unsupportedArgs = args
      .where((arg) => !_supportedArgs.contains(arg))
      .toList();
  if (unsupportedArgs.isNotEmpty) {
    stderr.writeln('Unsupported argument(s): ${unsupportedArgs.join(', ')}');
    _printUsage();
    exitCode = 64;
    return;
  }

  final noOpen = args.contains('--no-open');

  stdout.writeln('Running Flutter tests with coverage...');
  var commandExitCode = await _runCommand('flutter', ['test', '--coverage']);
  if (commandExitCode != 0) {
    exit(commandExitCode);
  }

  stdout.writeln('Generating HTML report with genhtml...');
  commandExitCode = await _runCommand('genhtml', [
    'coverage/lcov.info',
    '-o',
    'coverage/html',
  ]);
  if (commandExitCode != 0) {
    stderr.writeln('Failed to generate HTML coverage report.');
    stderr.writeln(
      'Make sure lcov/genhtml is installed and available in PATH.',
    );
    if (Platform.isLinux) {
      stderr.writeln(
        'Debian/Ubuntu install command: sudo apt-get install lcov\n Red-Hat/Fedora install command: sudo dnf install lcov',
      );
    }
    exit(commandExitCode);
  }

  final htmlReportPath = File('coverage/html/index.html').absolute.path;
  stdout.writeln('Coverage report generated: $htmlReportPath');

  if (noOpen) {
    return;
  }

  stdout.writeln('Opening coverage report in browser...');
  commandExitCode = await _openInBrowser(htmlReportPath);
  if (commandExitCode != 0) {
    stderr.writeln('Could not open browser automatically.');
    stderr.writeln('Open this file manually: $htmlReportPath');
    exit(commandExitCode);
  }
}

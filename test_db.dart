import 'dart:io';

void main() {
  final home = Platform.environment['HOME'];
  final dbPath = '$home/.local/share/macro_tracker/macro_tracker.sqlite'; 
  // Drift's native database uses getApplicationDocumentsDirectory().
  stdout.writeln('Checking DB at: $dbPath');
}


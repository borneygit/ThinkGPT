import 'dart:io';

bool isDesktop() {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}
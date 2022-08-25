class Tools {
  static void logToConsole(Object message) {
    bool allowLogs = false;
    // ignore: avoid_print
    if (allowLogs) print(message);
  }
}

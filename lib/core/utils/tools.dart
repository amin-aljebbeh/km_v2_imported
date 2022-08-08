class Tools {
  static void logToConsole(Object message) {
    bool allowLogs = true;
    // ignore: avoid_print
    if (allowLogs) print(message);
  }
}

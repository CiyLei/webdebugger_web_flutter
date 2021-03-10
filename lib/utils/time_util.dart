class TimeUtil {
  static String formatTime(int time) {
    return time < 10 ? "0$time" : time.toString();
  }
}

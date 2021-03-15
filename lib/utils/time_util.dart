/// 时间相关工具类
class TimeUtil {
  /// 格式化时间输出，保证2位
  static String formatTime(int time) {
    return time < 10 ? "0$time" : time.toString();
  }
}

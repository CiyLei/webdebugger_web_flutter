/// 全局静态变量存储地
class Constant {
  /// 是否模拟数据
  static const mock = true;

  /// 模拟的请求地址，开启了mock后，接口请求的地址不会从地址栏获取，而是用这个mock的地址
  static const mockHostName = "192.168.33.248";

  /// 模拟的请求端口
  static const mockPort = "8080";
}

import 'package:flutter/widgets.dart';

/// “控制台”模块的状态存储
class ConsoleProvider with ChangeNotifier {
  /// “控制台”模块，默认的导入代码
  var codeImport = '''
import android.widget.Toast;
import java.util.Random;
''';

  /// “控制台”模块，默认的执行代码
  var code = '''
int i = 0;
while(i < 10) {
    System.out.println(new Random().nextInt());
    i++;
}
Toast.makeText(getContext(), "测试吐司", Toast.LENGTH_SHORT).show();
  ''';

  /// “控制台”模块，默认的返回结果
  var result = "";

  /// 是否高亮语法
  bool isHighlight = false;

  /// “控制台”模块，控制代码是否运行在主线程中
  var isRunMainThread = true;
}

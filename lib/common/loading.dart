import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Container(
            height: 10,
          ),
          Text("加载中")
        ],
      ),
    );
  }
}

class LoadError extends StatelessWidget {
  VoidCallback retryCallback;
  VoidCallback errorCallback;

  LoadError(
      {Key key, @required this.retryCallback, @required this.errorCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: this.retryCallback,
              child: Padding(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text("加载失败，点击重试"),
                    )
                  ],
                ),
                padding: EdgeInsets.all(6),
              )),
          Tooltip(
            message: "查看具体错误",
            child: IconButton(
              onPressed: this.errorCallback,
              icon: Icon(Icons.info),
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }
}

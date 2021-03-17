import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:webdebugger_web_flutter/common/flashing_point.dart';
import 'package:webdebugger_web_flutter/common/provider/media_provider.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';
import 'dart:js' as js;

class Media extends StatefulWidget {
  @override
  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  @override
  Widget build(BuildContext context) {
    var mediaProvider = context.read<MediaProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            _buildButtonWidget(ElevatedButton(
                onPressed: ApiStore.instance.mediaList, child: Text("刷新"))),
            _buildButtonWidget(ElevatedButton(
                onPressed: ApiStore.instance.screenCapture, child: Text("截屏"))),
            _buildButtonWidget(ElevatedButton(
              onPressed: () {
                if (mediaProvider.flashingPointController.isFlashing) {
                  mediaProvider.flashingPointController.stopFlash();
                  ApiStore.instance.stopScreenRecording();
                } else {
                  mediaProvider.flashingPointController.startFlash();
                  ApiStore.instance.startScreenRecording();
                }
                setState(() {});
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlashingPoint(
                    radius: 3,
                    flashingPointController:
                        mediaProvider.flashingPointController,
                  ),
                  SizedBox(width: 6),
                  Text(mediaProvider.flashingPointController.isFlashing
                      ? "结束录屏"
                      : "开始录屏")
                ],
              ),
            )),
            _buildButtonWidget(ElevatedButton(
                onPressed: () {
                  ApiStore.instance.cleanMediaList();
                  mediaProvider.clearMediaList();
                },
                child: Text("清空"))),
          ],
        ),
        Expanded(child: MediaGrid())
      ],
    );
  }

  /// 构建按钮的widget
  Widget _buildButtonWidget(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: child,
    );
  }
}

/// 媒体网格
class MediaGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaProvider = context.watch<MediaProvider>();
    return mediaProvider.mediaPathList.isEmpty
        ? Center(child: Text("无媒体文件"))
        : GridView.extent(
            maxCrossAxisExtent: 400,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.5,
            children: mediaProvider.mediaPathList
                .map((e) {
                  var url = ApiStore.mediaUrl(mediaProvider.mediaPort, e);
                  return Column(
                    key: ValueKey(e),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              js.context.callMethod('open', [
                                ApiStore.mediaUrl(mediaProvider.mediaPort, e)
                              ]);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(50)),
                              child: url.endsWith("mp4")
                                  ? MediaVideoPlayer(url: url)
                                  : Image.network(ApiStore.mediaUrl(
                                      mediaProvider.mediaPort, e)),
                            )),
                      ),
                      SizedBox(height: 8),
                      SelectableText(e)
                    ],
                  );
                })
                .toList()
                .reversed
                .toList(),
          );
  }
}

class MediaVideoPlayer extends StatefulWidget {
  final String url;

  MediaVideoPlayer({Key key, @required this.url}) : super(key: key);

  @override
  _MediaVideoPlayerState createState() => _MediaVideoPlayerState();
}

class _MediaVideoPlayerState extends State<MediaVideoPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      icon: Icon(_controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow)),
                ),
              )
            ],
          )
        : Center(
            child: Icon(Icons.slow_motion_video, size: 80),
          );
  }
}

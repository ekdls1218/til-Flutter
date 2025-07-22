import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  bool showControls = false;

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(oldWidget.video.path != widget.video.path) {
      initailizeController();
    }
  }

  @override
  void initState() {
    super.initState();

    initailizeController(); // 컨트롤러 초기화
  }

  initailizeController() async { // 선택한 동영상으로 컨트롤러 초기화
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();
    
    videoController.addListener(videoControllerListener); // videoController가 변경될 때마다 실행
    
    setState(() {
      this.videoController = videoController;
    });
  }

  // 동영상 재생 상태(videpController)가 변경될 때마다 실행 -> build()를 재실행
  void videoControllerListener() {
    setState(() {});
  }
  
  // State가 폐기될 때 같이 폐기할 함수들 실행
  @override
  void dispose() {
    // videoControllerListener 삭제
    videoController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(videoController == null){ // 컨트롤러 초기화 전
      return Center(
        child: CircularProgressIndicator(), // 로딩 중
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio( // 위젯의 비율을 정할 수 있는 위젯
        aspectRatio: videoController!.value.aspectRatio, // videoController에 연결된 영상의 가로:세로 비율
        child: Stack( // 위로 쌓을 수 있는 위젯
          children: [
            VideoPlayer(
              videoController!,
            ),
            if(showControls)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            Positioned( // child 위젯의 위치를 정할 수 있는 위젯
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    renderTimeTextFromDuration(
                      videoController!.value.position,
                    ),
                    Expanded(
                        child: Slider( // 동영상 재생 상태를 보여주는 슬라이더
                          onChanged: (double val){ // 슬라이더가 이동할 때마다 실행할 함수
                            videoController!.seekTo( // 재생 위치 이동
                              Duration(seconds: val.toInt()),
                            );
                          },
                          // 현재 동영상 재생 위치(초단위로 표현)
                          value: videoController!.value.position.inSeconds.toDouble(),
                          min: 0,
                          max: videoController!.value.duration.inSeconds.toDouble(),
                        ),
                    ),
                    renderTimeTextFromDuration(
                      videoController!.value.duration,
                    )
                  ],
                ),
              )
            ),
            if (showControls)
              Align( // 오른쪽 위
                alignment: Alignment.topRight,
                child: CustomIconButton(
                    onPressed: widget.onNewVideoPressed,
                    iconData: Icons.photo_camera_back
                ),
              ),
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row( // 가로 배치
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton( // 3초 되감기
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    CustomIconButton( // 재생/일시정지
                      onPressed: onPlayPressed,
                      iconData: videoController!.value.isPlaying ? // 재생중이면
                      Icons.pause : Icons.play_arrow, // 일시정지 : 재생
                    ),
                    CustomIconButton( // 3초 빨리 감기
                      onPressed: onForwardPressed,
                      iconData: Icons.rotate_right,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}: ${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  void onReversePressed() { // 3초 되감기
    final currentPosition = videoController!.value.position; // 현재 실행 중인 위치

    Duration position = Duration(); // 0초로 실행 위치 초기화

    if (currentPosition.inSeconds > 3) { // 현재 실행 위치가 3초보다 길면
      position = currentPosition - Duration(seconds: 3); // 3초 빼기
    }

    videoController!.seekTo(position); // 실행 위치 변경
  }

  void onForwardPressed() { // 3초 빨리 감기
    final maxPosition = videoController!.value.duration; // 동영상 길이
    final currentPosition = videoController!.value.position; // 동영상 현재 위치

    Duration position = maxPosition; // 동영상 길이로 실행 위치 초기화

    // 동영상 길이에서 3초 뺀 값이 현재 위치 값보다 클 때
    if((maxPosition - Duration(seconds: 3)).inSeconds > currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3); // 3초 더하기
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    if(videoController!.value.isPlaying) { // 동영상이 재생 중이면
      videoController!.pause(); // 일시정지
    }else {
      videoController!.play(); // 재생
    }
  }
}

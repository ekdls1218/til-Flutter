import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key?key}) : super(key:key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: video == null? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onNewVideoPressed, // onTap 매개 변수에 onNewVideoPressed() 함수 입력
          ),
          SizedBox(height: 30.0),
          _AppName(),
        ],
      ),
    );
  }

  void onNewVideoPressed() async { // 이미지 선택 기능 구현 함수
    final video = await ImagePicker().pickVideo( // 동영상 선택
        source: ImageSource.gallery, // 갤러리에서 선택
    );

    if(video != null) { // 동영상이 있다면
      setState(() {
        this.video = video; // video 변수에 저장
      });
    }
  }
  
  BoxDecoration getBoxDecoration() { // Container 그라데이션 효과 함수
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A3A7C),
            Color(0xFF000118),
          ],
      ),
    );
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
        video: video!,
      ),
    );
  }
}


class _Logo extends StatelessWidget{
  final GestureTapCallback onTap; // onTap 함수 선언
  const _Logo({
    required this.onTap, // 반드시 받기
    Key? key,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( //onTap( ) 함수를 외부로부터 입력
      onTap: onTap,
      child: Image.asset('asset/img/logo.png'),
    );
  }
}

class _AppName extends StatelessWidget{
  const _AppName({Key?key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VIDEO',
          style: textStyle,
        ),
        Text(
          'PLAYER',
          style: textStyle.copyWith(
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
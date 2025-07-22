import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget{
  // 중복 코딩 방지를 위해 기본 틀에 아이콘과 아이콘 클릭 시 실행 함수만 외부에서 받아오는걸로
  final GestureTapCallback onPressed;
  final IconData iconData;

  const CustomIconButton({
    required this.onPressed,
    required this.iconData,
    Key? key,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed, // 아이콘을 눌렀을 때 실행할 함수
        iconSize: 30.0, // 아이콘 크기
        color: Colors.white, // 아이콘 색깔
        icon: Icon( // 아이콘
          iconData,
        ),
    );
  }
}


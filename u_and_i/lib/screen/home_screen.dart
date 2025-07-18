import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        body: SafeArea( // 시스템 UI 피해서 UI 그리기
            top: true,
            bottom: false,
            child: Column(
              // 위아래 끝에 위젯 배치
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              // 반대축 최대 크기로 늘리기
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DDay(
                  onHeartPressed: onHeartPressed,
                  firstDay: firstDay,
                ),
                _CoupleImage()
              ],
            ))
    );
  }

  void onHeartPressed() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 300,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime date) {
                  setState(() {
                    firstDay = date;
                  },
                  );
                },
              ),
            )
          );
        },
      barrierDismissible: true, // 외부 탭할 경우 다이얼로그 닫기
    );
  }
}

class _DDay extends StatelessWidget {
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  _DDay({
    required this.onHeartPressed,
    required this.firstDay,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Column(
      children: [
        const SizedBox(height: 16.0),
        Text(
            'U&I',
            style: textTheme.headlineLarge
        ),
        const SizedBox(height: 16.0),
        Text(
            '우리 처음 만난 날',
          style: textTheme.bodyLarge,
        ),
        Text(
          '${firstDay.year}.${firstDay.month}.${firstDay.day}',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16.0),
        IconButton(
            iconSize:60.0,
            onPressed: onHeartPressed,
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
        ),
        const SizedBox(height: 16.0),
        Text(
            'D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}',
            style: textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class _CoupleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center( // 이미지 중앙 정렬
      child: Image.asset(
        'asset/img/middle_image.png',
        // 화면의 반만큼 높이 구현
        // Expanded 사용 시 Expanded가 우선 순위를 갖게되어 무시
        height: MediaQuery.of(context).size.height / 2,
      ),
    );
  }
}
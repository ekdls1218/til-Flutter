
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key?key}) : super(key:key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      Duration(seconds: 3), (timer) {
        // print('실행');

        // 현재 페이지 가져오기
        int? nextPage = pageController.page?.toInt();

        // 페이지 값이 없을 때 리턴(예외처리)
        if(nextPage == null) {
          return;
        }

        if(nextPage == 4) { // 마지막 페이지일 때
          nextPage == 0; // 첫 페이지로
        }else{ // 아니라면
          nextPage++; // 페이지 + 1
        }
        // 페이지 변경
        pageController.animateToPage(nextPage,
            duration: Duration(milliseconds: 500), // 페이지 이동 시 소요 시간
            curve: Curves.ease,// 페이지 변경 애니메이션 작동 방식
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle((SystemUiOverlayStyle.dark));

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [1, 2, 3, 4, 5]
            .map(
              (num) => Image.asset(
                  'asset/img/image_$num.png',
                  fit: BoxFit.contain,
              ),
        ).toList(),
      ),
    );
  }
}
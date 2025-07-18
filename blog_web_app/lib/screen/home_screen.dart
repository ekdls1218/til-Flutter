import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted) // 자바스크립트 허용
    ..loadRequest(Uri.parse('https://blog.codefactory.ai')); // 초기 url
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Orange'), // 앱바 타이틀 설정
        centerTitle: true, // 앱바 타이들 가운데 정렬, false는 왼쪽 정렬

        actions: [
          IconButton(onPressed: () {
            controller.loadRequest(Uri.parse('https://blog.codefactory.ai'));
          },
            icon: Icon(
              Icons.home,
            ),
          ),
        ],
      ),
      body: WebViewWidget(controller:controller),
    );
  }
}

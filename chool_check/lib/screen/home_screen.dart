import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget{
  static final LatLng companyLatLng = LatLng( // 위도,경도 표현 클래스
    37.56937062729273, // 위도
    126.98609972497482, // 경도
  );

  // 회사 위치 마커 선언
  static final Marker marker = Marker(
      markerId: MarkerId('company'),
      position: companyLatLng,
  );

  // 회사 위치 반경 원 모양으로 선언
  static final Circle circle = Circle(
    circleId: CircleId('choolCheckCircle'),
    center: companyLatLng, // 원의 중심이 되는 위치
    fillColor: Colors.blue.withOpacity(0.5), // 원의 색상
    radius: 100, // 원의 반지름
    strokeColor: Colors.blue, // 원의 테두리 색
    strokeWidth: 1, // 원의 테두리 두께
  );

  const HomeScreen({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          // 로딩 상태
          if(!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // 로딩 중 표시
            );
          }
          // 권한 허가된 상태
          if(snapshot.data == '위치 권한이 허가 되었습니다.') {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: GoogleMap( // 구글 지도 위젯
                    initialCameraPosition: CameraPosition( // 처음 지도 로딩 시 위치 지정
                      target: companyLatLng, // 설정한 위도/경도 지점이 중심
                      zoom: 16, // 확대 정도(클수록 확대)
                    ),
                    myLocationEnabled: true, // 내 위치 지도에 보여주기
                    markers: Set.from([marker]), // Set로 Marker 제공
                    circles: Set.from([circle]), // Set로 Circle 제공
                  ),
                ),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timelapse_outlined,
                          color: Colors.blue,
                          size: 50.0,
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async{
                            final curPosition = await Geolocator.getCurrentPosition(); // 현재 위치
                            final distance = Geolocator.distanceBetween( // 현재 위치와 회사 위치 간의 거리
                              curPosition.latitude, // 현재 위치 위도
                              curPosition.longitude, // 현재 위치 경도
                              companyLatLng.latitude, // 회사 위치 위도
                              companyLatLng.longitude, // 회사 위치 경도
                            );

                            bool canCheck = // 거리 체크
                                distance < 100; // 거리 간격이 100보다 작으면 true

                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog( // 다이얼로그
                                    title: Text('출근하기'), // 다이얼로그 제목
                                    content: Text( // 다이얼로그 본문
                                      canCheck ? '출근을 하시겠습니까?' : '출근할 수 없는 위치입니다.'
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: (){
                                            Navigator.of(context).pop(false); // 다이얼로그 닫기
                                          },
                                          child: Text('취소'), // 하단 선택 버튼
                                      ),
                                      if(canCheck)
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false); // 다이얼로그 닫기
                                          },
                                          child: Text('출근하기'), // 하단 선택 버튼
                                        ),
                                    ],
                                  );
                                });
                          },
                          child: Text('출근하기!'),
                        ),
                      ],
                    )
                )
              ],
            );
          }

          // 기타 모든 경우(위치 서비스 미활성화, 권한 거절 등)
          return Center(
            child: Text(
              snapshot.data.toString(), // snapshot.data에 담긴 메시지를 화면에 그대로 출력
            ),
          );
        },
      ),
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true, // 타이틀 중앙 정렬
      title: Text( // 타이틀 텍스트
        '오늘도 출근',
        style: TextStyle( // 텍스트 스타일
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white, // 배경 컬러
    );
  }

  Future<String> checkPermission() async { // 권한 확인 후 요청
    // 위치 서비스 활성화 여부 확인
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if(!isLocationEnabled) { // 위치 서비스가 활성화 안되어있으면(false)면
      return '위치 서비스를 활성화해주세요.';
    }

    // 위치 권한 확인
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if(checkedPermission == LocationPermission.denied) { // 위치 권한 거절 상태일 때
      checkedPermission = await Geolocator.requestPermission(); // 권한 요청

      if(checkedPermission == LocationPermission.denied) { // 위치 권한 거절했을 때
        return '위치 권한을 허가해주세요.';
      }
    }

    if(checkedPermission == LocationPermission.deniedForever) {// 위치 권한 거절 상태일 때(앱에서 재요청 불가)
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    return '위치 권한이 허가 되었습니다.'; // 위 조건이 모두 통과하면 위치 권한 허가 완료
  }

}
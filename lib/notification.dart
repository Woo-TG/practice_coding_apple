import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();


//1. 앱로드시 실행할 기본설정
initNotification(context) async {

  //안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('app_icon');

  //ios에서 앱 로드시 유저에게 권한요청하려면, 알람띄우기 전 허락받는 코드
  var iosSetting = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting
  );
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    onDidReceiveNotificationResponse: (payload){        // 함수명추가
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Text('새로운 페이지'),
        )
      );
    }
  );
}


//2. 이 함수 원하는 곳에서 실행하면 알림 뜸
showNotification() async {

  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      '제목1',
      '내용1',
      NotificationDetails(android: androidDetails, iOS: iosDetails),

  );
}

showNotification2() async {

  tz.initializeTimeZones();

  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알림 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  notifications.zonedSchedule(
      2,
      '제목2',
      '내용2',

      tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),   // 앞부분: 현재시간 .add() 시간 더하기 가능
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,

      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime
  );
}
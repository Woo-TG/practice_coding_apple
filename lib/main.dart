import 'package:flutter/material.dart';
import 'style.dart' as style;

void main() {
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: style.theme,
          home: const MyApp())
  );
}

class MyApp extends StatefulWidget {
   const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;  // state에 현재 UI의 상태 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram', style: TextStyle(color: Colors.black54),),
        actions: [
          IconButton(
              icon:Icon(Icons.add_box_outlined),
              onPressed: (){},
              iconSize: 30,
          )
        ]
      ),
      body: [Text('홈'), Text('샵페이지')][tab],    // state에 따라 UI 어떻게 보일지 작성
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){                            // 유저도 state 조작할 수 있게 코드 작성
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),
    );
  }
}

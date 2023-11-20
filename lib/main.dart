import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;



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
  var tab = 0;// state 현재 UI의 상태 저장

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    print(result2);
  }
  
  @override
  void initState() {
    super.initState();
    getData();
  }

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
      body: [Home(), Text('샵페이지')][tab],    // state 따라 UI 어떻게 보일지 작성
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, i) {
          return Column(
            children: [
              Image.network('http://codingapple1.github.io/kona.jpg'),
              Container(
                constraints: BoxConstraints(maxWidth: 600),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('좋아요 100'),
                    Text('글쓴이'),
                    Text('글내용'),
                  ],
                ),
              )
            ],
          );
        }
    );
  }
}

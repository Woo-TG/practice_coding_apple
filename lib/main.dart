import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';  // 스크롤 관련 함수

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: style.theme,
      home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0; // state 현재 UI의 상태 저장
  var data = [];

  addData(a){
    setState(() {
      data.add(a);
    });
  }

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));

    if (result.statusCode == 200) {
      print(jsonDecode(result.body));
    } else {
      throw Exception('실패함');
    }

    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
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
          title: Text(
            'Instagram',
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () {},
              iconSize: 30,
            )
          ]),
      body: [Home(data: data, addData: addData,), Text('샵페이지')][tab], // state 따라 UI 어떻게 보일지 작성
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          // 유저도 state 조작할 수 있게 코드 작성
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, this.data, this.addData});
  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }


  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent){
        getMore();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
  print(widget.data);
    if (widget.data.isNotEmpty){       // data에 리스트가 있으면 true
      return ListView.builder(
          itemCount: 3,
          controller: scroll,
          itemBuilder: (context, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.data[i]['image']),
                Text('좋아요 ${widget.data[i]['likes']}'),
                Text(widget.data[i]['user']),
                Text(widget.data[i]['content']),
              ],
            );
          }
      );
    } else {
      return CircularProgressIndicator();
    }


  }
}

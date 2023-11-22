import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart'; // 스크롤 관련 함수
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

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
  var userImage;
  var userContent;

  saveData() async {
    var storage = await SharedPreferences.getInstance();

    storage.setString('map', jsonEncode({'age': 20}));
    var result = storage.getString('map') ?? '없는데요';
    print(jsonDecode(result)['age']);
  }

  addMyData() {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      data.insert(0, myData); // List 맨 앞에 추가, add(myData) - 맨 뒤에 추가
    });
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));

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
    saveData();
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
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    userImage = File(image.path); // state의 변경이므로
                  });
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Upload(
                            userImage: userImage,
                            setUserContent: setUserContent,
                            addMyData: addMyData)));
              },
              iconSize: 30,
            )
          ]),
      body: [
        Home(
          data: data,
          addData: addData,
        ),
        Text('샵페이지')
      ][tab], // state 따라 UI 어떻게 보일지 작성
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
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    if (widget.data.isNotEmpty) {
      // data에 리스트가 있으면 true
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (context, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data[i]['image'].runtimeType ==
                        String // runtimeType : 왼쪽 타입 출력해주삼
                    ? Image.network(widget.data[i]['image'])
                    : Image.file(widget.data[i]['image']),
                GestureDetector(
                  child: Text(widget.data[i]['user']),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, a1, a2) => Profile(),  // 파라미터 3개 그냥 채워야 됨
                            transitionsBuilder: (context, a1, a2, child) =>  // a1:animation object - 새 페이지 전환효과(0~1)
                                FadeTransition(opacity: a1, child: child),   // a2: 기존 페이지 에니메이션

                              // SlideTransition(       // 슬라이드 형식
                              //     position: Tween(
                              //       begin: Offset(-1.0,0.0),  // x좌표(-1 : 왼, 1: 오), y좌표(위, 아래)
                              //       end: Offset(0.0, 0.0),
                              //     ).animate(a1),
                              //   child: child,
                              // )
                        )
                    );
                  },
                ),
                Text('좋아요 ${widget.data[i]['likes']}'),
                Text(widget.data[i]['user']),
                Text(widget.data[i]['content']),
              ],
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }
}

class Upload extends StatelessWidget {
  const Upload(
      {super.key, this.userImage, this.setUserContent, this.addMyData});
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                addMyData();
              },
              icon: Icon(Icons.send)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('이미지업로드화면'),
          TextField(
            onChanged: (text) {
              setUserContent(text);
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
        ],
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('프로필페이지'),
    );
  }
}

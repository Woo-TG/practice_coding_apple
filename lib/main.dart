import 'package:contact/shop.dart';

import 'notification.dart';
import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter/rendering.dart'; // 스크롤 관련 함수
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,);

  runApp(MultiProvider(      //store 원하는 위젯에 등록하기, materialApp를 감싸면 자식 위젯 모두 사용가능
    providers: [
      ChangeNotifierProvider(create: (c) => Store1()),
      ChangeNotifierProvider(create: (c) => Store2()),
    ],

    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: style.theme,
        home: const MyApp()),
  ));
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
    var storage = await SharedPreferences.getInstance();   // 데이터 저장
    storage.setString('map', jsonEncode({'age': 20}));    // map 형태

    var result = storage.getString('map') ?? '없는데요';  // 저장했던 자료 출력 & null check
    print(jsonDecode(result)['age']);                   // 자료 삭제  storage.remove('name')
  }

  // saveData() async {
  //   var storage = await SharedPreferences.getInstance();
  //   storage.setString('name', 'johg');     // 다양한 형태의 자료 저장 가능
  //   storage.setBool('name', true);
  //   storage.setInt('name', 20);
  //   storage.setDouble('name', 20.5);
  //   storage.setStringList('name', ['john', 'park']);
  //
  //   storage.remove('name');                           // 자료 삭제
  //   var result = storage.getString('name');
  //   print(result);
  // }


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
  void initState() {    // 실행
    super.initState();
    initNotification(context);
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){showNotification2();}, child: Text('+'),),
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
        Home(data: data, addData: addData,),
        Shop()][tab], // state 따라 UI 어떻게 보일지 작성

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
                            pageBuilder: (context, a1, a2) => Profile(),  // 파라미터 3개 그냥 채워야 됨 , c 의미없음
                            transitionsBuilder: (context, a1, a2, child) =>  // a1:animation object - 새 페이지 전환효과(0~1)
                                FadeTransition(opacity: a1, child: child),   // a2: 기존 페이지 에니메이션, 4번째: 현재 보여주는 위젯

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
                Text('${widget.data[i]['date']}'),
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

class Store2 extends ChangeNotifier {
  var name = 'john kim';
}

class Store1 extends ChangeNotifier {
  var follower = 0;
  var friend = false;  // 기본값
  var profileImage = [];
  
  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }
  
  addFollower(){
    if (friend == false){    // 친구가 아니면 +1 그리고 true로 바꿈.
      follower ++;
      friend = true;
    } else {
      follower --;
      friend = false;
    }
    notifyListeners();
  }
  // changeName(){
  //   name = 'john park';
  //   notifyListeners();   // 재렌더링 해주는 코드
  // }

}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name),),  //provider 사용
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: ProfileHeader()),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (context, i) => Image.network(context.watch<Store1>().profileImage[i]),
                  childCount: context.watch<Store1>().profileImage.length
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)
          )
        ],
      )
    );
  }
}


class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context.watch<Store1>().follower}명'),
        ElevatedButton(
            onPressed: (){
              // context.read<Store1>().changeName();      // 함수 실행하고 싶을때
              context.read<Store1>().addFollower();
            },
            child: Text('팔로우')
        ),
        ElevatedButton(
            onPressed: (){
              context.read<Store1>().addFollower();
            },
            child: Text('사진가져오기')
        ),
      ],
    );
  }
}

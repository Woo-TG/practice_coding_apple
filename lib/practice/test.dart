import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
          home:MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var total = 3;
  var name = ['김영숙', '홍길동', '피자집'];
  var like = [0, 0, 0];

  addOne() {
   setState(() {
     total++;
   });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Icon(Icons.expand_more),
            title: Text(total.toString()),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
              IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
              IconButton(onPressed: () {}, icon: Icon(Icons.notification_add))
            ],
          ),

          body: ListView.builder(
              itemCount: name.length,
              itemBuilder: (context,i){
                return ListTile(
                  leading: Image.asset('images/camera.jpg'),
                  title: Text(name[i]),
                );
              }
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showDialog(context: context, builder: (context){
                return DialogUI(addOne : addOne);
              });
            },
          ),
        );
  }
}

class DialogUI extends StatelessWidget {
   DialogUI({super.key, required this.addOne});
  final addOne;

  var inputDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(
              controller: inputDate,
              decoration: InputDecoration(
                icon: Icon(Icons.star),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 0.5
                  )
                )
              ),
            ),
            TextButton(
                onPressed: (){addOne();},
                child: Text('완료')),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  },
                child: Text('취소'))
          ],
        ),
      ),
    );
  }
}

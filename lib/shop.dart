import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  // getData() async {
  //   var result = await firestore.collection('product').get();
  //   if(result.docs.isNotEmpty){
  //     for(var doc in result.docs){
  //       print(doc['name']);
  //   }
  //  }
  // }

  // getData() async{
  //   try {
  //     /*var result = await auth.createUserWithEmailAndPassword(*/    // 유저 회원가입,
  //     await auth.signInWithEmailAndPassword(     // 로그아웃 : auth.signOut()
  //         email: "kim@test.com",
  //         password: "123456",
  //     );
  //
  //   } catch(e){
  //     print(e);
  //   }
  //   if(auth.currentUser?.uid == null){
  //     print('로그인 안된 상태');
  //   } else {
  //     print('로그인 함');
  //   }
  // }

  getData() async{
    await firestore.collection('product').get();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지임!!'),
    );
  }
}

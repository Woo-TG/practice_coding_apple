import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  getData() async {
    var result = await firestore.collection('product').get();
    if(result.docs.isEmpty){
      for(var doc in result.docs){
        print(doc['name']);
    }
   }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지임!!'),
    );
  }
}

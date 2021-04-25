import 'package:flutter/material.dart';
import 'package:life_record/pages/add_item/add_item_page.dart';
import 'package:life_record/pages/item_detail/item_detail_page.dart';
import 'package:life_record/pages/item_list/item_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '生活记录',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemListPage(title: '生活记录'),
      routes: {
        'lrapp://root/add/item':(context)=> AddItemPage(),
        'lrapp://root/item/detail':(context){
          return ItemDetailPage();
        },
      },
    );
  }
}



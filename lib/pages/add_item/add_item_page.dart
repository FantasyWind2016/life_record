import 'package:flutter/material.dart';
import 'package:life_record/utils/db_util.dart';

class AddItemPage extends StatefulWidget {
  AddItemPage({Key key}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  var titleTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('创建事项'),),
      body: Column(
        children: [
          Row(
            children: [
              Text('名称：'),
              Expanded(
                child: TextField(
                  controller: titleTextController,
                ),
              ),
            ]
          ),
          FlatButton(
            onPressed: () async {
              await DBUtil.instance.insertItem({'name': titleTextController.text});
              Navigator.of(context).pop();
            },
            child: Text('提交'),
          ),
        ],
      ),
    );
  }
}
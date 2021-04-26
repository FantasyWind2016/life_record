import 'package:flutter/material.dart';
import 'package:life_record/utils/db_util.dart';

class AddItemPage extends StatefulWidget {
  AddItemPage({Key key}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  String title = '创建事项';
  int itemID;
  Map itemData = {};
  queryItem() async {
    itemData = await DBUtil.instance.queryItem(this.itemID);
    titleTextController.text = itemData['name'];
    setState(() {
      
    });
  }

  var titleTextController = TextEditingController();
  @override
  void didChangeDependencies() {
    this.itemID = ModalRoute.of(context).settings.arguments;
    if (this.itemID==null) {
      
    } else {
      setState(() {
        title =  '修改信息';
      });
      queryItem();
    }
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Column(
        children: [
          Row(
            children: [
              Text('名称：'),
              Expanded(
                child: TextField(
                  controller: titleTextController,
                  onChanged: (value){
                    setState(() {
                      
                    });
                  },
                ),
              ),
            ]
          ),
          FlatButton(
            onPressed: titleTextController.text == itemData['name'] ? null : () async {
              if (this.itemID==null) {
                await DBUtil.instance.insertItem({'name': titleTextController.text});
              } else {
                await DBUtil.instance.updateItem(this.itemID, {'name': titleTextController.text});
              }
              
              Navigator.of(context).pop();
            },
            child: Text('提交'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_record/utils/db_util.dart';

class ItemDetailPage extends StatefulWidget {
  ItemDetailPage({Key key}) : super(key: key) {
  }

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int itemID;
  Map itemData = {};
  List<Map> records = [];
  queryItem() async {
    itemData = await DBUtil.instance.queryItem(this.itemID);
    setState(() {
      
    });
  }

  queryRecords() async {
    records = await DBUtil.instance.queryItemRecords(this.itemID);
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    this.itemID = ModalRoute.of(context).settings.arguments;
    queryItem();
    queryRecords();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('事项详情'),),
      body: Column(
        children: [
          Row(
            children:[
              Expanded(
                child: FlatButton(
                  color: Colors.red,
                  child: Text(
                    '删除事项',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: (){

                  },
                ),
              ),
              Expanded(
                child: FlatButton(
                  color: Colors.green,
                  child: Text(
                    '修改信息',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: (){

                  },
                ),
              ),
            ]
          ),
          Row(
            children: [
              Text('名称：'),
              Text('${itemData['name']??'未命名'}'),
            ]
          ),
          Container(
            child: Text('记录列表：'),
          ),
          Expanded(
            child: records==null || records.isEmpty ? Container(child:Text('暂无数据')) : ListView.builder(
              itemCount: records.length,
              itemBuilder: (BuildContext context, int index) {
                var data = records[index];
                return ListTile(
                  title: Text('${index+1}: ${data['date']}'),
                  trailing: Container(
                    width: 60,
                    height: 30,
                    child: FlatButton(
                      onPressed: (){
                        DBUtil.instance.deleteRecord(data['id']).then((value){
                          showCupertinoDialog(
                            context: context, 
                            builder: (BuildContext context){
                              return CupertinoAlertDialog(
                                title: Text('提示'),
                                content: Text('删除成功'),
                                actions: <Widget>[
                                  FlatButton(onPressed: (){
                                    queryRecords();
                                    Navigator.of(context).pop();
                                  }, child: Text('确定')),
                                ],
                              );
                            },
                          );
                        });
                      }, 
                      child: Icon(Icons.delete, color: Colors.white,),
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
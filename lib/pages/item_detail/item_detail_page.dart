import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_record/mixin/color_mixin.dart';
import 'package:life_record/mixin/get_mixin.dart';
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
      appBar: AppBar(
        title: Text('事项详情'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              Get.bottomSheet(
                Container(
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        child: ListTile(
                          leading: Icon(Icons.edit, color: Colors.white,),
                          title: Text(
                            '修改信息',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Get.back();
                            Get.toNamed('lrapp://root/add/item', arguments: this.itemID);
                          }          
                        ),
                      ),
                      Container(
                        color: Colors.red,
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.white,),
                          title: Text(
                            '删除事项',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Get.back();
                            GetMixin.confirmDialog('是否删除该事项？', (){
                              DBUtil.instance.deleteItem(this.itemID).then((value) {
                                GetMixin.infoDialog('事项删除成功✨✨✨', dismissed: (){
                                  Get.back();
                                });
                              });
                            });
                          },          
                        ),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
              );
            }, 
            icon: Icon(Icons.edit), 
            label: Text('操作'),
            textColor: Colors.white,
          ),
        ],
      ),
      body: Container(
        color: ColorMixin.backgroudColor,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '名称：',
                  style: TextStyle(
                    color: ColorMixin.mainTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('${itemData['name']??'未命名'}'),
              ]
            ),
            Container(
              height: 44,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '记录列表：',
                      style: TextStyle(
                        color: ColorMixin.mainTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoButton(
                      onPressed: (){
                        Get.toNamed('lrapp://root/add/record', arguments: {'item_id': this.itemID});
                      },
                      child: Text(
                        '添加记录',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      color: Colors.blue,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
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
                        onPressed: () {
                          GetMixin.confirmDialog('是否删除记录？', (){
                            DBUtil.instance.deleteRecord(data['id']).then((value){
                              GetMixin.infoDialog('记录删除成功', dismissed: ()=>queryRecords());
                            });
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
      ),
    );
  }
}
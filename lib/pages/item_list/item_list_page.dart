import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:life_record/utils/cache_util.dart';
import 'package:life_record/utils/db_util.dart';
import 'package:simple_animations/simple_animations.dart';

class ItemListPage extends StatefulWidget {
  ItemListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List _itemList = [];

  void _incrementCounter() {
    Navigator.of(context).pushNamed('lrapp://root/add/item').then((title) {
      refreshData();
    });
  }

  void refreshData() async {
    var list = await DBUtil.instance.queryDistinctNewestRecords(null);
    _itemList = list.map((data){
      var date = data['max_date'];
      var time = DateTime.tryParse(date??'');
      return {
        'id': data['item_id'],
        'title': '${data['name']}',
        'count': '${data['count']??0}',
        'lastDate': time==null?'':'${time.year}-${time.month}-${time.day}',
        'lastTime': time==null?'':'${time.hour}:${time.minute}:${time.second}',
      };
    }).toList();
    setState(() {
    });
  }

  addRecord(int index) async {
    Map<String, dynamic> value = _itemList[index];
    var time = DateTime.now();
    var id = await DBUtil.instance.insertRecord({
      'item_id': value['id'],
      'date': time.toString(),
    });
    if (id is int) {
      refreshData();
    }
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track('color1').add(Duration(seconds: 1), ColorTween(
        begin: Colors.red, end: Colors.green,
      )),
      Track('color2').add(Duration(seconds: 1), ColorTween(
        begin: Colors.green, end: Colors.blue,
      )),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              Navigator.of(context).pushNamed('lrapp://root/app/setting');
            }, 
            icon: Icon(Icons.settings), 
            label: Text('设置'),
            textColor: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: GridView.builder(
          itemCount: _itemList.length,
          itemBuilder: (context, index) {
            var item = _itemList[index];
            return GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed('lrapp://root/item/detail', arguments: item['id']);
              },
              onLongPress: () {
                CacheUtil.getData(enableRecordConfirmKey).then((onValue){
                  if (onValue==true) {
                    showCupertinoDialog(context: context, builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text('确认操作'),
                        content: Text('是否记录数据？'),
                        actions: <Widget>[
                          FlatButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text('取消')),
                          FlatButton(onPressed: (){
                            addRecord(index);
                            Navigator.of(context).pop();
                          }, child: Text('确认')),
                        ],
                      );
                    });
                  } else {
                    addRecord(index);
                  }
                });
              },
              child: ControlledAnimation(
                playback: Playback.MIRROR,
                tween: tween,
                duration: tween.duration,
                builder: (context, anmation) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [anmation['color1'], anmation['color2']]
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(_itemList[index]['title']),
                        Text('执行${_itemList[index]['count']??0}次'),
                        Text('${_itemList[index]['lastDate']??''}'),
                        Text('${_itemList[index]['lastTime']??''}'),
                      ],
                    ),
                  );
                }
              ),
            );
          },
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

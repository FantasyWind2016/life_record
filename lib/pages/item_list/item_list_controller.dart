import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_record/pages/add_item/add_item_page.dart';
import 'package:life_record/utils/cache_util.dart';
import 'package:life_record/utils/db_util.dart';
import 'package:date_format/date_format.dart';

class ItemListController extends GetController with SingleTickerProviderStateMixin {
  static ItemListController get to => Get.find();

  List itemList = [];
  AnimationController colorAnimation;
  int shiningId = -1;

  ItemListController(){
    colorAnimation = AnimationController(vsync: this, duration: Duration(seconds: 1), reverseDuration: Duration(seconds:1));
  }

  void refreshData() async {
    var list = await DBUtil.instance.queryDistinctNewestRecords(null);
    itemList = list.map((data){
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
    update(this);
  }

  void addItem() {
    Get.to(AddItemPage()).then((title){
      refreshData();
    });
  }

  refreshItemData(Map item) async {
    print('refreshItemData:$item');
    var list = await DBUtil.instance.queryDistinctNewestRecords({'item_id': item['id']});
    var data = list.first;
    var date = data['max_date'];
    var time = DateTime.tryParse(date??'');
    item['count'] = '${data['count']??0}';
    item['lastDate'] = time==null?'':'${time.year}-${time.month}-${time.day}';
    item['lastTime'] = time==null?'':'${time.hour}:${time.minute}:${time.second}';
    update(this);
  }

  addRecord(Map item) async {
    print('addRecord:$item');
    Map value = item;
    var time = DateTime.now();
    var dateTimeStr = formatDate(time, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    var id = await DBUtil.instance.insertRecord({
      'item_id': value['id'],
      'date': dateTimeStr,
    });
    if (id is int) {
      CacheUtil.getData(enableRecordSuccessSnackBarKey).then((onValue){
        if (onValue==null || onValue==true) {
          Get.snackbar('操作提示', '记录成功✨✨✨', backgroundColor: Colors.white);
        }
      });
      
      shiningId = item['id'];
      colorAnimation.reset();
      colorAnimation.forward().then((_)=>colorAnimation.reverse().then((_){
        shiningId = -1;
      }));
      refreshItemData(item);
    }
  }
  
}
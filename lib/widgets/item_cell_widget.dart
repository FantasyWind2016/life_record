import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_record/mixin/get_mixin.dart';
import 'package:life_record/pages/item_list/item_list_controller.dart';
import 'package:life_record/utils/cache_util.dart';

class ItemCellWidget extends StatelessWidget {
  final int index;
  ItemCellWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemListController>(
      builder: (ctl) {
        var item = ctl.itemList[index];
        return GestureDetector(
          onTap: (){
            Get.toNamed('lrapp://root/item/detail', arguments: item['id']).then((onValue){
              ctl.refreshItemData(item);
            });
          },
          onLongPress: () {
            CacheUtil.getData(enableRecordConfirmKey).then((onValue){
              if (onValue==null || onValue==true) {
                GetMixin.confirmDialog('是否记录数据？', ()=>ctl.addRecord(item));
              } else {
                ctl.addRecord(item);
              }
            });
          },
          child: ValueListenableBuilder(
            valueListenable: ctl.colorAnimation,
            builder:(context, data, child) {
              if (ctl.shiningId!=item['id']) {
                return Container(
                  color: Colors.blue,
                  child: child,
                );
              }
              return Container(
                color: Color.lerp(Colors.blue, Colors.red, data),
                child: child,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(item['title']),
                Text('执行${item['count']??0}次'),
                Text('${item['lastDate']??''}'),
                Text('${item['lastTime']??''}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
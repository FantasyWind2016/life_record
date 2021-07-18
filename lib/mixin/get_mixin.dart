import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

mixin GetMixin on Get {
  static Future<T> confirmDialog<T>(content, Function confirmed, {String title, String confirmTitle, String cancelTitle, Function canceled}) {
    assert(content!=null, 'in GetMixin.infoDialog, the argument content must not null.');
    assert(confirmed!=null, 'in GetMixin.infoDialog, the argument confirmed must not null.');
    return Get.dialog(
      CupertinoAlertDialog(
        title: Text(title??'确认操作'),
        content: Text(content),
        actions: <Widget>[
          CupertinoButton(
            child: Text(cancelTitle ?? '取消'), 
            onPressed: (){
              Get.back();
              if (canceled!=null) {
                canceled();
              }
            }
          ),
          CupertinoButton(
            child: Text(confirmTitle ?? '确定'), 
            onPressed: (){
              Get.back();
              if (confirmed!=null) {
                confirmed();
              }
            }
          ),
        ],
      )
    );
  }
  static Future<T> infoDialog<T>(content, {String title, String confirmTitle, Function dismissed}) {
    assert(content!=null, 'in GetMixin.infoDialog, the argument content must not null.');
    return Get.dialog<T>(
      CupertinoAlertDialog(
        title: Text(title ?? '提示'),
        content: Text(content),
        actions: <Widget>[
          CupertinoButton(
            child: Text(confirmTitle ?? '确定'), 
            onPressed: (){
              Get.back();
              if (dismissed!=null) {
                dismissed();
              }
            }
          ),
        ],
      )
    );
  }
}
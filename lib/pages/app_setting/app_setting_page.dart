import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_record/utils/cache_util.dart';

class AppSettingPage extends StatefulWidget {
  AppSettingPage({Key key}) : super(key: key);

  @override
  _AppSettingPageState createState() => _AppSettingPageState();
}

class _AppSettingPageState extends State<AppSettingPage> {
  bool enableRecordConfirm = true;
  bool enableRecordSuccessSnackBar = true;
  
  @override
  void didChangeDependencies() {
    CacheUtil.getData(enableRecordConfirmKey).then((onValue){
      if (onValue!=null) {
        setState(() {
          enableRecordConfirm = onValue;
        });
      }
    });
    CacheUtil.getData(enableRecordSuccessSnackBarKey).then((onValue){
      if (onValue!=null) {
        setState(() {
          enableRecordSuccessSnackBar = onValue;
        });
      }
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('首页记录前确认弹框'),
              trailing: CupertinoSwitch(
                value: enableRecordConfirm, 
                onChanged: (value){
                  CacheUtil.saveData(enableRecordConfirmKey, value);
                }
              ),
            ),
            ListTile(
              title: Text('首页记录成功后顶部提示'),
              trailing: CupertinoSwitch(
                value: enableRecordSuccessSnackBar, 
                onChanged: (value){
                  CacheUtil.saveData(enableRecordSuccessSnackBarKey, value);
                }
              ),
            ),
          ],
        ),
      )
    );
  }
}
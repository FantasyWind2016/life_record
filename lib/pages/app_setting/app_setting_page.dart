import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSettingPage extends StatefulWidget {
  AppSettingPage({Key key}) : super(key: key);

  @override
  _AppSettingPageState createState() => _AppSettingPageState();
}

class _AppSettingPageState extends State<AppSettingPage> {
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
              title: Text('记录前确认弹框'),
              trailing: CupertinoSwitch(
                value: true, 
                onChanged: (value){

                }
              ),
            ),
          ],
        ),
      )
    );
  }
}
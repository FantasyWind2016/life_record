import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart' hide Locale;
import 'package:life_record/utils/db_util.dart';

class AddRecordPage extends StatefulWidget {
  AddRecordPage({Key key}) : super(key: key);

  @override
  _AddRecordPageState createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  String title = '新增记录';
  int itemID;
  int recordID;
  Map recordData = {};
  queryRecord() async {
    recordData = await DBUtil.instance.queryItem(this.recordID);
    setState(() {
      
    });
  }

  @override
  void didChangeDependencies() {
    var arg = ModalRoute.of(context).settings.arguments;
    if (arg is Map) {
      this.itemID = arg['item_id'];
      this.recordID = arg['record_id'];
    }
    
    if (this.recordID==null) {
      
    } else {
      setState(() {
        title =  '修改信息';
      });
      queryRecord();
    }
    
    super.didChangeDependencies();
  }

  var _date = '';
  _showDatePicker() async {
    Locale myLocale = Localizations.localeOf(context);
    var picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        locale: myLocale);
    setState(() {
      _date = formatDate(picker, [yyyy, '-', mm, '-', dd]);
    });
  }

  var _time = '';
  _showTimePicker() async {
    var picker =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      _time = formatDate(DateTime(0, 0, 0, picker.hour, picker.minute), [HH, ':', nn, ':', ss]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Column(
        children: [
          Row(
            children: [
              Text('日期：'),
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    _showDatePicker();
                  }, 
                  child: Text(_date),
                ),
              ),
            ]
          ),
          Row(
            children: [
              Text('时间：'),
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    _showTimePicker();
                  }, 
                  child: Text(_time),
                ),
              ),
            ]
          ),
          FlatButton(
            onPressed: '$_date $_time' == recordData['date'] ? null : () async {
              if (this.recordID==null) {
                var id = await DBUtil.instance.insertRecord({
                  'item_id': this.itemID,
                  'date': '$_date $_time',
                });
                print('$id');
              } else {
                await DBUtil.instance.updateItem(this.recordID, {'date': '$_date $_time'});
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
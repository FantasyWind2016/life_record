import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_record/pages/app_setting/app_setting_page.dart';
import 'package:life_record/pages/item_list/item_list_controller.dart';
import 'package:life_record/widgets/item_cell_widget.dart';

class ItemListPage extends StatelessWidget {
  ItemListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              Get.to(AppSettingPage());
            }, 
            icon: Icon(Icons.settings), 
            label: Text('设置'),
            textColor: Colors.white,
          ),
        ],
      ),
      body: GetBuilder(
        init: ItemListController(),
        initState: (state){
          ItemListController.to.refreshData();
        },
        builder:(ctrl) => GridView.builder(
          itemCount: ctrl.itemList.length,
          itemBuilder: (context, index) {
            return ItemCellWidget(index);
          },
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ItemListController.to.addItem(),
        tooltip: '添加事项',
        child: Icon(Icons.add),
      ),
    );
  }
}

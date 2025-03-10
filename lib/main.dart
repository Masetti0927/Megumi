import 'package:flutter/material.dart';
import 'search_bar.dart'; // 导入搜索栏组件
import 'package:flutter/rendering.dart'; // 导入调试相关库

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('搜索示例')),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: MySearchBar(),
        ),
      ),
    );
  }
}
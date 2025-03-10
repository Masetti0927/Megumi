import 'package:flutter/material.dart';
import 'search_page.dart';

class MySearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false, // 设置为透明
            pageBuilder: (context, animation, secondaryAnimation) =>
                SearchPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0); // 从下方滑入
              var end = Offset.zero;
              var curve = Curves.easeOut; // 动画曲线

              var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600]),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '搜索',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            Icon(Icons.filter_list, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> _recentSearches = [];
  TextEditingController _controller = TextEditingController();
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  _saveRecentSearches(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches.removeLast();
      }
      await prefs.setStringList('recentSearches', _recentSearches);
    }
  }

  _confirmClearRecentSearches() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认清除？'),
          content: Text('此操作将删除所有搜索历史记录，无法恢复。'),
          actions: [
            TextButton(
              onPressed: () {
                _clearRecentSearches();
                Navigator.of(context).pop();
              },
              child: Text('确认', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  _clearRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentSearches');
    setState(() {
      _recentSearches.clear();
    });
  }

  _confirmDeleteSingleSearch(String search) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认删除？'),
          content: Text('是否删除 "$search" ？'),
          actions: [
            TextButton(
              onPressed: () {
                _clearRecentSearches();
                Navigator.of(context).pop();
              },
              child: Text('确认', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  _deleteSingleSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.remove(search);
    });
    await prefs.setStringList('recentSearches', _recentSearches);
  }

  void _toggleShowAll() {
    setState(() {
      _showAll = !_showAll;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
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
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: '搜索',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (query) {
                                _saveRecentSearches(query);
                                print('搜索：$query');
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[600]),
                            onPressed: () {
                              _controller.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '历史记录',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // 原有的清空按钮
                    if (_recentSearches.isNotEmpty)
                      TextButton.icon(
                        onPressed: _confirmClearRecentSearches,
                        icon: Icon(Icons.delete, color: Colors.grey[700]),
                        label: Text(
                          '清空',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    Text('|', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    // 新增的显示全部按钮
                    if (_recentSearches.length > 3)
                      TextButton(
                        onPressed: _toggleShowAll,
                        child: Text(
                          _showAll ? '收起' : '展开',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _showAll
                    ? _recentSearches.length
                    : (_recentSearches.length > 3 ? 3 : _recentSearches.length),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.only(left: 8),
                    leading: Icon(Icons.history),
                    title: Text(_recentSearches[index]),
                    onTap: () {
                      print('搜索：${_recentSearches[index]}');
                      Navigator.pop(context);
                    },
                    onLongPress: () {
                      _confirmDeleteSingleSearch(_recentSearches[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
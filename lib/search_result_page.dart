import 'package:flutter/material.dart';
import 'search.dart';
import 'result_json.dart';

class SearchResultPage extends StatelessWidget {
  final String query;

  SearchResultPage({required this.query});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController(text: query);

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
                      Navigator.popUntil(context, (route) => route.isFirst);
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
                              decoration: InputDecoration(
                                hintText: '搜索',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (newQuery) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            SearchResultPage(query: newQuery),
                                  ),
                                );
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
          SizedBox(height: 16),
          Expanded(
            child: Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: search(keyword: query,limit: 10).then(processSearchResults),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final results = snapshot.data!;
                  if (results.isEmpty) {
                    return Center(child: Text('未找到搜索结果'));
                  }

                  return ListView.builder(
                    itemCount: results.length > 10 ? 10 : results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];
                      final String imageUrl =
                          '${item["albumPicUrl"]}?param=100x100';
                      final String title = item["name"];
                      final String artists = (item["artists"] as List<String>)
                          .join(' / ');

                      return ListTile(
                        leading: Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          artists,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        onTap: () {
                          // 这里可以添加点击事件处理
                        },
                      );
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

import 'dart:convert';
import 'search.dart';

List<Map<String, dynamic>> processSearchResults(String jsonResponse) {
  final Map<String, dynamic> decoded = json.decode(jsonResponse);
  final List<dynamic> resources = decoded["data"]?["resources"] ?? [];
  List<Map<String, dynamic>> results = [];

  for (var item in resources) {
    final baseInfo = item["baseInfo"]?["simpleSongData"];
    if (baseInfo == null || baseInfo["fee"] == 1) continue;

    final String name = baseInfo["name"] ?? "";
    final int id = baseInfo["id"] ?? 0;
    final List<dynamic> artistsData = baseInfo["ar"] ?? [];
    final List<String> artists =
    artistsData.map((artist) => artist["name"] as String).toList();
    final String albumName = baseInfo["al"]?["name"] ?? "";
    final String albumPicUrl = baseInfo["al"]?["picUrl"] ?? "";

    results.add({
      "name": name,
      "id": id,
      "artists": artists,
      "albumName": albumName,
      "albumPicUrl": albumPicUrl,
    });
  }

  return results;
}

void run() async{
  String res = await search(keyword: "洛天依");
  print(res);

  var after = processSearchResults(res);
  print(after);

}

void main() async {
  await measureTime(() async {
    run();
  });
}

Future<void> measureTime(Future<void> Function() action) async {
  final stopwatch = Stopwatch()..start();
  await action();
  stopwatch.stop();
  print('执行时间: ${stopwatch.elapsedMilliseconds} 毫秒');
}
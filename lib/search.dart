import 'package:demo/utils/utils.dart';

import 'dart:async';

import 'request.dart';
import 'param.dart';
import 'music_api.dart';
import 'package:http/http.dart' as http;


Future<String> search({required String keyword}) async{

  //单曲搜索用path和url
  String path = MusicApi.Path.list;
  String url = MusicApi.Url.list;

  //生成请求体参数
  String searchData = ParamsGen.getListData(keyword: keyword);
  String md5 = ParamsGen.generateMd5Hash(path: path, data: searchData);
  String meta = ParamsGen.generateMeta(path, searchData, md5);
  String param = ParamsGen.generateParam(meta);

  //发送请求
  String response =  await Request.sendRequest(param, url: url);
  // String res = response.bodyBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  return CryptoUtil.decryptFromHex(response);
}


void main() async {
  await measureTime(() async {
    run();
  });
}

void run() async {
  print("Starting...");
  String res = await search(keyword: "洛天依");
  print("Request finished");

}

Future<void> measureTime(Future<void> Function() action) async {
  final stopwatch = Stopwatch()..start();
  await action();
  stopwatch.stop();
  print('执行时间: ${stopwatch.elapsedMilliseconds} 毫秒');
}


import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'utils/utils.dart';

class ParamsGen {
  static const header = {
    "clientSign":
        "68:54:5A:DC:B3:65@@@W4Z3HH83@@@@@@943d28f929ca2a56adb43a6cc7a62fab708fcbca9780c38c1d947cbe0bc66f88",
    "os": "pc",
    "appver": "3.1.4.203507",
    "deviceId": "11233AE4DE043F607D494F2446302435F2DA1CF2F02F74346C26",
    "requestId": 0,
    "osver": "Microsoft-Windows-10-Professional-build-22631-64bit",
  };

  //使用请求数据生成md5校验
  static String generateMd5Hash({required String path, required String data}) {
    String input = "nobody" + path + "use" + data + "md5forencrypt";
    return md5.convert(utf8.encode(input)).toString();
  }

  //将信息整合用于AES加密
  static String generateMeta(String path, String data, String md5) {
    return "$path-36cd479b6b5-$data-36cd479b6b5-$md5";
  }

  //生成加密参数
  static String generateParam(String meta) {
    return CryptoUtil.encryptToHex(meta);
  }

  //根据对应请求生成数据
  //生成歌曲数据
  static String getMusicData({required String ids, String level = "standard"}) {
    Map<String, dynamic> data = {
      "ids": jsonEncode([ids]),
      "level": level,
      "immerseType": "c51",
      "encodeType": "flac",
      "trialMode": "42",
      "e_r": true,
      "header": header,
    };
    return jsonEncode(data);
  }

  //生成搜索列表数据
  static String getListData({
    required String keyword,
    int limit = 10,
    int offset = 0,
  }) {
    Map<String, dynamic> data = {
      "keyword": keyword,
      "scene": "NORMAL",
      "limit": limit,
      "offset": offset,
      "needCorrect": "true",
      "e_r": true,
      "header": header,
    };
    return jsonEncode(data);
  }
}

void main() {
  print(
    ParamsGen.generateParam(
      """/api/search/song/list/page-36cd479b6b5-{"keyword":"洛天依","scene":"NORMAL","limit":"1","offset":"0","needCorrect":"true","e_r":true,"header":{"clientSign":"68:54:5A:DC:B3:65@@@W4Z3HH83@@@@@@943d28f929ca2a56adb43a6cc7a62fab708fcbca9780c38c1d947cbe0bc66f88","os":"pc","appver":"3.1.4.203507","deviceId":"11233AE4DE043F607D494F2446302435F2DA1CF2F02F74346C26","requestId":0,"osver":"Microsoft-Windows-10-Professional-build-22631-64bit"}}-36cd479b6b5-9ed2c797fe808c9cb053722b3bbaa3f1""",
    ),
  );
}

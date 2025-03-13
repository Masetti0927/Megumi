import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:convert/convert.dart';

//请求体加解密
class CryptoUtil {
  static const String _EAPI_KEY = "e82ckenh8dichen8";
  static final Key _key = Key(utf8.encode(_EAPI_KEY));
  static final Encrypter _encrypter = Encrypter(
    AES(_key, mode: AESMode.ecb, padding: null),
  );

  // HEX 解密为字符串
  static String decryptFromHex(String hexCipher) {
    final encryptedBytes = Uint8List.fromList(hex.decode(hexCipher));
    final decryptedBytes = _encrypter.decryptBytes(Encrypted(encryptedBytes));
    final decryptedText = utf8.decode(
      _pkcs7Unpad(Uint8List.fromList(decryptedBytes)),
    );
    return decryptedText;
  }

  /// 字符串加密为 HEX
  static String encryptToHex(String plainText) {
    final paddedText = _pkcs7Pad(Uint8List.fromList(utf8.encode(plainText)));
    final encryptedBytes = _encrypter.encryptBytes(paddedText).bytes;
    return hex.encode(encryptedBytes).toUpperCase();
  }

  /// PKCS7 填充
  static Uint8List _pkcs7Pad(Uint8List data) {
    final blockSize = 16;
    final padLength = blockSize - (data.length % blockSize);
    return Uint8List.fromList([...data, ...List.filled(padLength, padLength)]);
  }

  /// PKCS7 去填充
  static Uint8List _pkcs7Unpad(Uint8List data) {
    final padLength = data.last;
    return data.sublist(0, data.length - padLength);
  }
}

void main() {

  final encryptedHex =
      "FA90B329E9614F79E79598F37DC2EDB487F00D1BC4C9B24CD57E6C318B9073569338432CD7D98D1A3626E997A2C531216D269EF69D86D3666D1A2EE4EFFFACA05D6B922CC9A41E58D1E22EF8FDF01C841F082C8FFD2ED8DA82F09A8528B2B2C65D484C15CD13BCCA5C311C790DB8896F6FE4A57FB6090E6A59BAF34C12A60A590338596BE73AE185A0AA4FBBBB3212799D7CA4F6749261A0393179CB405BB1B9F825BD1E4A1B628C251A3C215C33D9F16A784405425E598ECF037122A3E63673348B4CA91FFE972598F1D39F2DABEA8195AD3988D43C396B4B684A483E5DBC9D108202B36C87507E3EB45C03B3F47FDB8EF1941DF8ED4812FBB4D66726FCF1D5035F18C00E90D51D946A4FF98712A25709B4AEAFE0FE0559CA40980F8D3D012A78BE10136C8787449E401E0F0628E62906FFF602676E28F8AB2069E6F37676382FD0B43338AB3E9D457419B5E3557AAE0E0492DD526C2F11CBAFECB4D9EF626A211EA37F7EA64C3B9DB5E01282A2BD36D9FCD8274C7C38FEAE099525BFBE222B66AAFDB96458FC6054F884ADA75548C59176D814F7DB6CC47886E8BC04115A5FAB9B22A1055838D62F4CE8B97B37512C4537AF5DB85E45D6093F331D6B046AB10D83A3E74F47BDDB4000D1FE3F9DB1A243D4449FF98B74E566474D27310D494DDB7811606F2C3BBA2CCD663CFC6765639C6476F9C884C42D7F657782783B33C3F96663E5FD03384B5D380B8B4F3EF767"; // 替换为你的加密 HEX
  final decryptedText = CryptoUtil.decryptFromHex(encryptedHex);
  print(decryptedText);
  print("解密结果: $decryptedText");

  final text = """/api/search/song/list/page-36cd479b6b5-{"keyword":"洛天依","scene":"NORMAL","limit":"1","offset":"0","needCorrect":"true","e_r":true,"header":{"clientSign":"68:54:5A:DC:B3:65@@@W4Z3HH83@@@@@@943d28f929ca2a56adb43a6cc7a62fab708fcbca9780c38c1d947cbe0bc66f88","os":"pc","appver":"3.1.4.203507","deviceId":"11233AE4DE043F607D494F2446302435F2DA1CF2F02F74346C26","requestId":0,"osver":"Microsoft-Windows-10-Professional-build-22631-64bit"}}-36cd479b6b5-9ed2c797fe808c9cb053722b3bbaa3f1""";
  final encryptedHexResult = CryptoUtil.encryptToHex(text);
  print("加密结果: $encryptedHexResult");

  print(encryptedHex == encryptedHexResult);

}

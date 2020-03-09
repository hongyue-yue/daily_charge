import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class FileStorage {
  Future<String> get _localPath async {
    final tempDir = await getApplicationDocumentsDirectory();
    Directory directory = new Directory('${tempDir.path}/bill');
    if (!directory.existsSync()) {
      directory.createSync();
      print('文档初始化成功，文件保存路径为 ${directory.path}');
    }
    return directory.path;
  }

  Future<List> readFile(String filePath) async {
    final dirPath = await _localPath;
    File file = new File('$dirPath/$filePath.txt');
    if (!file.existsSync()) {
      return [];
    }
    String billStr = await file.readAsString();
    return JsonDecoder().convert(billStr);
  }

  Future<List> getFileList() async {
    final tempDir = await getApplicationDocumentsDirectory();
    Directory directory = new Directory('${tempDir.path}/bill');
    List list = directory.listSync();
    return list;
  }

  Future<bool> writeBill(Map obj, String filePath) async {
    try {
      final dirPath = await _localPath;
      File file = new File('$dirPath/$filePath.txt');
      if (!file.existsSync()) {
        file.createSync();
      }
      String billStr = await file.readAsString();
      List billArr = [];
      if (billStr.length > 0) {
        billArr = JsonDecoder().convert(billStr);
      }
      billArr.add(obj);
      billStr = JsonEncoder().convert(billArr);
      print(billStr);
      await file.writeAsString(billStr);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final storage = new FileStorage();

String formatDate(DateTime time, String format) {
  //日期格式化函数
  var o = {
    "yyyy": time.year.toString(),
    "yy": time.year.toString().substring(2),
    "MM": (time.month < 10 ? "0" : "") + time.month.toString(),
    "M": time.month.toString(),
    "dd": (time.day < 10 ? "0" : "") + time.day.toString(),
    "d": time.day.toString(),
    "HH": (time.hour < 10 ? "0" : "") + time.hour.toString(),
    "H": time.hour.toString(),
    "hh": (time.hour % 12 < 10 ? "0" : "") + (time.hour % 12).toString(),
    "h": (time.hour % 12).toString(),
    "mm": (time.minute < 10 ? "0" : "") + time.minute.toString(),
    "m": time.minute.toString(),
    "ss": (time.second < 10 ? "0" : "") + time.second.toString(),
    "s": time.second.toString(),
    "w": ['一', '二', '三', '四', '五', '六', '日'][time.weekday - 1],
  };
  var keys = o.keys;
  for (var k in keys) {
    format = format.replaceAll(k, o[k]);
  }
  return format;
}

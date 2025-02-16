import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Store the last request timestamp
Future<void> storeLastRequestTime() async {
  final currentTime = DateTime.now().toIso8601String();
  await storage.write(key: 'last_request_time', value: currentTime);
}

Future<DateTime?> getLastRequestTime() async {
  String? lastRequestTimeStr = await storage.read(key: 'last_request_time');
  if (lastRequestTimeStr != null) {
    return DateTime.parse(lastRequestTimeStr);
  }
  return null;
}

Future<bool> shouldFetchNewData() async {
  DateTime? lastRequestTime = await getLastRequestTime();
  if (lastRequestTime == null) {
    return true;
  }
  DateTime now = DateTime.now();
  if (lastRequestTime.year != now.year ||
      lastRequestTime.month != now.month ||
      lastRequestTime.day != now.day) {
    return true;
  }

  return false;
}

Future<void> fetchAndSaveSubData(List<dynamic> subjectCodes) async {
  await dotenv.load(fileName: ".env");

  String? baseUrl = dotenv.env['URL'];
  String? path = dotenv.env['FULL_DATA'];
  String? token = await storage.read(key: 'jwt_token');

  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Bypass-Tunnel-Reminder': "1",
  };

   // if (await shouldFetchNewData()) {
    List<String> subjectCodesStr = subjectCodes.map((e) => e.toString()).toList();
    final Uri url = Uri.http(baseUrl!, '/api/subjects/${subjectCodesStr.join(",")}$path');

    try {
      final response = await http.get(url, headers: headers);
      print("🌍 Fetching data from: $url");

      if (response.statusCode == 200) {
        Map<String, dynamic> resData = jsonDecode(response.body);
        for (String code in subjectCodesStr) {
          if (resData.containsKey(code)) {
            await saveSubjectData(code, resData[code]);
          } else {
            print("⚠️ Warning: No data found for subject code: $code");
          }
        }

        // Only store the current timestamp after a successful API call
        await storeLastRequestTime();
      } else {
        print("❌ Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching data: $e");
    }
  // } else {
  //   print("⏳ Skipping fetch. Last request was less than 1 day ago.");
  // }
}

Future<void> saveSubjectData(String subjectCode, Map<String, dynamic> data) async {
  try {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory subjectDir = Directory('${appDir.path}/subjects/$subjectCode');

    if (!await subjectDir.exists()) {
      await subjectDir.create(recursive: true);
    }

    for (String key in data.keys) {
      String filePath = '${subjectDir.path}/$key.json';
      File file = File(filePath);
      await file.writeAsString(jsonEncode(data[key]));
      print("✅ Saved $key data for $subjectCode at $filePath");
    }
  } on FileSystemException catch (e) {
    print("❌ FileSystemException while saving $subjectCode data: $e");
  } catch (e) {
    print("❌ Unexpected error while saving $subjectCode data: $e");
  }
}

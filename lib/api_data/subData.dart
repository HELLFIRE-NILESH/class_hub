import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Store the last subject fetch timestamp
Future<void> storeLastSubFetchTime() async {
  final currentTime = DateTime.now().toIso8601String();
  await storage.write(key: 'last_sub_fetch', value: currentTime);
}

// Get the last subject fetch timestamp
Future<DateTime?> getLastSubFetchTime() async {
  String? lastSubFetchTimeStr = await storage.read(key: 'last_sub_fetch');
  if (lastSubFetchTimeStr != null) {
    return DateTime.parse(lastSubFetchTimeStr);
  }
  return null;
}

// Check if the last subject fetch was more than 1 hour ago
Future<bool> shouldFetchData() async {
  DateTime? lastRequestTime = await getLastSubFetchTime();
  if (lastRequestTime == null) {
    return true;
  }

  // Check if the last request was made on a different day
  DateTime now = DateTime.now();
  if (lastRequestTime.year != now.year ||
      lastRequestTime.month != now.month ||
      lastRequestTime.day != now.day) {
    return true;
  }

  return false;
}


Future<List<Map<String, dynamic>>> fetchsubjectDetail(List<dynamic> subjectCodes) async {
  String cacheKey = subjectCodes.join(",");

  // Check if we should fetch data based on the last subject fetch time
  // if (await shouldFetchData()) {
    List<Map<String, dynamic>> data = await fetchSubFromApi(cacheKey);
    if (data.isNotEmpty) {
      print('Data fetched from API for subjects: $cacheKey');
      await storeLastSubFetchTime();
      return data;
    }
  // } else {
  //   print('⏳ Skipping fetch. Last subject fetch was less than 1 hour ago.');
  // }

  // If API fetch fails or was skipped, load the data from cache (file)
  print('Loading cached data from file for subjects: $cacheKey');
  return await loadSubDataFromFile(cacheKey);
}

Future<List<Map<String, dynamic>>> fetchSubFromApi(String cacheKey) async {
  try {
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['URL'];
    final url = Uri.http(baseUrl!, "/api/subjects/sub/$cacheKey");
    print('Fetching data from URL: $url');

    String? Token = await storage.read(key: 'jwt_token');

    final headers = {
      'Authorization': 'Bearer $Token',
      'Content-Type': 'application/json',
      'Bypass-Tunnel-Reminder': "1",
    };

    final res = await http.get(url, headers: headers);

    try {
      List<dynamic> decodedData = json.decode(res.body);
      final data = List<Map<String, dynamic>>.from(decodedData.map((item) => Map<String, dynamic>.from(item)));
      await saveSubDataToFile(cacheKey, data);
      return data;
    } catch (e) {
      print('Error decoding API response: $e');
      return [];
    }
  } catch (e) {
    print('Error fetching data from API: $e');
    return [];
  }
}

/// Save the fetched data to a file for future use.
Future<void> saveSubDataToFile(String cacheKey, List<Map<String, dynamic>> data) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final subDir = Directory('${directory.path}/subjects');

    // Ensure the directory exists
    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }

    final file = File('${subDir.path}/subjectData.json');
    await file.writeAsString(json.encode(data));
    print('Data saved successfully to: ${file.path}');
  } catch (e) {
    print('Error saving data to file: $e');
  }
}

/// Load cached data from a file if available.
Future<List<Map<String, dynamic>>> loadSubDataFromFile(String cacheKey) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final subDir = Directory('${directory.path}/subjects');
    final file = File('${subDir.path}/subjectData.json');

    // Check if the file exists
    if (await file.exists()) {
      String contents = await file.readAsString();
      List<dynamic> data = json.decode(contents);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print('No cached data found for subjects: $cacheKey');
      return [];
    }
  } catch (e) {
    print('Error loading data from file: $e');
    return [];
  }
}

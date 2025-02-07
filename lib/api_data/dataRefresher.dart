import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dataSavers.dart';
final storage = FlutterSecureStorage();

Future<String> _getLocalFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/refresh_times.json';
}

Future<void> storeRefreshTime(String subjectCode, String dataType) async {
  final currentTime = DateTime.now().toIso8601String();
  Map<String, Map<String, String>> refreshTimes = await getAllRefreshTimes();

  if (refreshTimes.containsKey(subjectCode)) {
    refreshTimes[subjectCode]?[dataType] = currentTime;
  } else {
    refreshTimes[subjectCode] = {dataType: currentTime};
  }

  await storeAllRefreshTimes(refreshTimes);
}

Future<Map<String, Map<String, String>>> getAllRefreshTimes() async {
  try {
    final filePath = await _getLocalFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final Map<String, dynamic> decodedData = jsonDecode(jsonString);

      // Cast to the expected type Map<String, Map<String, String>>
      return decodedData.map((key, value) {
        return MapEntry(
          key,
          Map<String, String>.from(value as Map), // Safely cast the inner map
        );
      });
    }
  } catch (e) {
    print('Error reading refresh times: $e');
  }
  return {};
}


Future<void> storeAllRefreshTimes(Map<String, Map<String, String>> refreshTimes) async {
  try {
    final filePath = await _getLocalFilePath();
    final file = File(filePath);
    final jsonString = jsonEncode(refreshTimes);
    await file.writeAsString(jsonString);
  } catch (e) {
    print('Error saving refresh times: $e');
  }
}

Future<DateTime?> getRefreshTime(String subjectCode, String dataType) async {
  Map<String, Map<String, String>> refreshTimes = await getAllRefreshTimes();
  String? refreshTimeStr = refreshTimes[subjectCode]?[dataType];
  if (refreshTimeStr != null) {
    return DateTime.parse(refreshTimeStr);
  }
  return null;
}

Future<void> storeLastRefreshTime() async {
  final currentTime = DateTime.now().toIso8601String();
  try {
    final filePath = await _getLocalFilePath();
    final file = File(filePath);
    await file.writeAsString(currentTime);
  } catch (e) {
    print('Error saving last refresh time: $e');
  }
}

Future<DateTime?> getLastRefreshTime() async {
  try {
    final filePath = await _getLocalFilePath();
    final file = File(filePath);
    if (await file.exists()) {
      String? lastRefreshTimeStr = await file.readAsString();
      return DateTime.parse(lastRefreshTimeStr);
    }
  } catch (e) {
    print('Error reading last refresh time: $e');
  }
  return null;
}

// Check if the last refresh was more than 1 minute ago
Future<bool> shouldRefreshData(String subjectCode, String dataType) async {
  DateTime? lastRefreshTime = await getRefreshTime(subjectCode, dataType);
  if (lastRefreshTime == null) {
    return true;
  }
  Duration difference = DateTime.now().difference(lastRefreshTime);
  return difference.inMinutes >= 1;
}

Future<Map<String, dynamic>> fetchSubjectData(String subjectCode, String dataType) async {
  await dotenv.load(fileName: ".env");

  String? baseUrl = dotenv.env['URL'];
  final Uri url = Uri.http(baseUrl!, "$subjectCode/$dataType");
  String? Token = await storage.read(key: 'jwt_token');

  // Define headers
  final headers = {
    'Authorization': 'Bearer $Token',
    'Content-Type': 'application/json',
    'Bypass-Tunnel-Reminder': "1",
  };

  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error fetching data for $subjectCode, $dataType: $e');
    rethrow; // Re-throw the error after logging
  }
}

Future<void> refreshData(BuildContext context, String subjectCode, String dataType) async {
  try {
    // Check if we should refresh the data based on the last refresh time for this subject/data type
    if (await shouldRefreshData(subjectCode, dataType)) {
      final Map<String, dynamic> data = await fetchSubjectData(subjectCode, dataType).timeout(Duration(seconds: 3));
      List<dynamic> dataList = data[dataType] as List<dynamic>;

      // Determine the appropriate save function based on dataType
      switch (dataType) {
        case 'assignment':
          await saveAssignments(int.parse(subjectCode), dataList);
          break;
        case 'downloads':
          await saveDownloads(int.parse(subjectCode), dataList);
          break;
        case 'notes':
          await saveNotes(int.parse(subjectCode), dataList);
          break;
        case 'sites':
          await saveSites(int.parse(subjectCode), dataList);
          break;
        case 'syllabus':
          await saveSyllabus(int.parse(subjectCode), dataList);
          break;
        default:
          throw Exception('Invalid data type');
      }

      // After a successful refresh, store the current time as the last refresh time for this subject/data type
      await storeRefreshTime(subjectCode, dataType);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data refreshed successfully!')),
      );
    } else {
      // Show message if not enough time has passed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wait for 1 minute before refreshing again.'),duration: Duration(seconds: 1),),
      );
    }
  } catch (e) {
    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loaded offline data '),duration: Duration(seconds: 1),),
    );
    print(e);
  }
}

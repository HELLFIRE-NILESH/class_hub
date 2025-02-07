import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Main function to fetch user data
Future<List<Map<String, dynamic>>> fetchUserData(String rollNo) async {
  try {
    List<Map<String, dynamic>> dataFromApi = await fetchDataFromApi(rollNo);
    if (dataFromApi.isNotEmpty) {
      print('API call successful, saving data and returning.');
      await _saveDataToFile(dataFromApi);
      return dataFromApi;
    } else {
      print('API call failed or returned empty, loading cached data.');
      return await loadUserDataFile();
    }
  } catch (e) {
    print('Error fetching data: $e');
    return await loadUserDataFile();
  }
}

// Function to fetch data from the API
Future<List<Map<String, dynamic>>> fetchDataFromApi(String rollNo) async {
  try {
    await dotenv.load(fileName: '.env');
    final baseUrl = dotenv.env['URL'];
    final path = dotenv.env['USER_PATH'];
    if (baseUrl == null || path == null) {
      print('Error: API URL or path is not configured in the .env file.');
      return [];
    }

    final url = Uri.http(baseUrl, '$path$rollNo');
    print('Fetching data from URL: $url');

    final token = await storage.read(key: 'jwt_token');
    if (token == null) {
      print('Error: No token found.');
      return [];
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Bypass-Tunnel-Reminder': "1",

  };

    final response = await http.get(url, headers: headers).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Unexpected data format: $data');
        return [];
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching data from API: $e');
    return [];
  }
}

// Function to save data to a local file
Future<void> _saveDataToFile(List<Map<String, dynamic>> data) async {
  try {
    final file = await _getLocalFile();
    await file.writeAsString(jsonEncode(data));
    print('Data saved to file.');
  } catch (e) {
    print('Error saving data to file: $e');
  }
}

// Function to load user data from the local file
Future<List<Map<String, dynamic>>> loadUserDataFile() async {
  try {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final contents = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(contents));
    } else {
      print('Cache file does not exist.');
      return [];
    }
  } catch (e) {
    print('Error reading data from file: $e');
    return [];
  }
}

// Function to get the local file for storing data
Future<File> _getLocalFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/userdata/userdata.json';
  final dir = Directory('${directory.path}/userdata');

  if (!await dir.exists()) {
    await dir.create(recursive: true);
    print('Directory created: ${dir.path}');
  }

  return File(path);
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../pages/userPage/loginPage.dart';
import 'initialData.dart';
import 'subData.dart';
import 'userInfo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiService {


  static final baseUrl = dotenv.env['URL'];

  static final FlutterSecureStorage storage = const FlutterSecureStorage();



  static Future<Map<String, dynamic>> login(String rollNo, String password) async {
    String? rollno;
    print(baseUrl);
    final url = Uri.http('$baseUrl','/api/auth/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"roll_no": rollNo, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "roll_no", value: rollNo);
      await storage.write(key: "jwt_token", value: data["token"]);
      print(data["token"]);

      rollno = await storage.read(key: 'roll_no');
      final userdata = await fetchUserData(rollno!);
      if (userdata.isNotEmpty) {
        var code = [...(userdata[0]['sub']), ...(userdata[0]['back_log'])];
        await fetchsubjectDetail(code);
        await fetchAndSaveSubData(code);
      } else {
        print("No data found");
      }


      return {"success": true, "message": "Login successful"};
    } else {
      final error = jsonDecode(response.body);
      return {"success": false, "message": error["error"] ?? "Login failed"};
    }
  }
  static Future<void> logout(BuildContext context) async {
    // Delete stored keys
    await storage.delete(key: "jwt_token");
    await storage.delete(key: "roll_no");

    // Get application documents directory and delete the userdata.json file
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/userdata/userdata.json';

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('userdata.json deleted successfully');
    }

    // Navigate to LoginPage and clear navigation history
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }


}

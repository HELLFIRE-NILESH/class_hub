import 'package:class_hub/api_data/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_data/initialData.dart';
import 'api_data/subData.dart';
import 'nav/navbar.dart';
import 'pages/userPage/loginPage.dart';
import 'theme/themeData.dart';

final storage = FlutterSecureStorage();
String? rollno;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFe5e8ea),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: const Color(0xFF1E4D4D),
      systemNavigationBarIconBrightness: Brightness.dark
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env'); // Load environment variables

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _checkTokenFuture;

  @override
  void initState() {
    super.initState();
    _checkTokenFuture = _checkJwtToken();
  }

  Future<bool> _checkJwtToken() async {
    String? jwtTok = await storage.read(key: 'jwt_token');
    if (jwtTok != null){
      rollno = await storage.read(key: 'roll_no');
      final userdata = await loadUserDataFile();
      if (userdata.isNotEmpty) {
        var code = [...(userdata[0]['sub']), ...(userdata[0]['back_log'])];
        await fetchAndSaveSubData(code).timeout(Duration(seconds: 3));
      } else {
        print("No data found");
      }
    }
    return jwtTok != null;
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkTokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white, // White background
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const NavView();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

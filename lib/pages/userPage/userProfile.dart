import 'package:class_hub/api_data/login.dart';
import 'package:class_hub/pages/creditPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:class_hub/api_data/userInfo.dart';
import '../../widgets/userProfile/backLogCard.dart';
import '../../widgets/userProfile/profileCard.dart';
import '../../widgets/userProfile/resultCard.dart';
import 'package:class_hub/theme/themeData.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isExpanded = false;
  String name = "Loading...";
  String rollNumber = "Loading...";
  String branch = "Loading...";
  String mobile = "Loading...";
  int sem = 0;

  List<dynamic> sgpa = [];
  List<dynamic> back_log = [];

  Future<void> _loadUserData() async {
    try {
      final data = await loadUserDataFile();
      setState(() {
        name = data[0]["name"];
        rollNumber = data[0]["roll_no"];
        branch = data[0]['branch'];
        mobile = data[0]['mobile_no'];
        sgpa = data[0]['sgpa'];
        back_log = data[0]['back_log'];
        sem = data[0]['sem'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => appCredit(),));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () {
               ApiService.logout(context);
              },
            ),
          ),
        ],
      ),
      backgroundColor: MyTheme.backgroundColor,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Section
              ProfileSection(
                semester: sem,
                isExpanded: isExpanded,
                onImageTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                name: name,
                mobile: mobile,
                branch: branch,
                rollNumber: rollNumber,
              ),

              const SizedBox(height: 24),

              // SGPA Section
              SGPACGPASection(sgpa: sgpa),

              const SizedBox(height: 24),

              // Backlog Section
              BacklogCard(backLogs: back_log),

              const SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }
}

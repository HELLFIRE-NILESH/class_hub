import 'package:flutter/material.dart';

import '../api_data/subData.dart';
import '../api_data/userInfo.dart';
import '../widgets/homePage/assignmentCard.dart';
import '../widgets/homePage/subjectCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<dynamic> sub = [];
  List<dynamic> back = [];
  List<Map<String, dynamic>> subData = [];
  List<Map<String, dynamic>> assData = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> _loadUserDataAndSubData() async {
    try {
      final userdata = await loadUserDataFile();
      if (userdata.isNotEmpty && userdata[0].containsKey('sub') || userdata[0].containsKey('back_log')) {
        setState(() {
          sub = userdata[0]['sub'] ?? [];
          back = [...sub, ...(userdata[0]['back_log'] ?? [])];

        });
        String codes = back.join(",");

        final combinedData = await loadSubDataFromFile(codes);
        setState(() {
          subData = combinedData;
          assData = combinedData.where((item) => sub.contains(item['sub_code'])).toList();

          isLoading = false;
        });
      } else {
        throw Exception('Invalid user data structure');
      }
    } catch (e) {
      setState(() {
        print(e);
        isLoading = false;
        errorMessage = 'Failed to load data. Please try again.';
      });
      debugPrint('Error fetching data: $e');

    }
  }

  @override
  void initState()  {
    super.initState();

    _loadUserDataAndSubData();


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ClassHub"),
        ),
        body: AnimatedSwitcher(
          duration:  Duration(milliseconds: 100),
          child: errorMessage.isNotEmpty
              ? Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          )
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Subjects Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                  child: Text("Subjects",style: Theme.of(context).textTheme.titleLarge,),
                ),
                const SizedBox(height: 20),


                SizedBox(
                  height: 175,
                  child: SubjectList(sub: subData),
                ),
                const SizedBox(height: 24),


                // Assignments Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                  child: Text("Assignments  ",style: Theme.of(context).textTheme.titleLarge,),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                  child: AssignmentList(sub: assData),
                ),
                const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

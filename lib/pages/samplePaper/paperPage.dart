import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousPaper extends StatefulWidget {
  const PreviousPaper({super.key});

  @override
  State<PreviousPaper> createState() => _PreviousPaperState();
}

class _PreviousPaperState extends State<PreviousPaper> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> papers = [
    {
      "subjectCode": "101",
      "subjectName": "Computer Fundamentals",
      "papers": ["3443 - 2019", "4242 - 2020", "32423 - 2021"],
    },
    {
      "subjectCode": "102",
      "subjectName": "Data Structures",
      "papers": ["2332 - 2023", "3232 - 2023", "5454 - 2022", "2343 - 2022"],
    },
    {
      "subjectCode": "104",
      "subjectName": "DBMS",
      "papers": ["3443 - 2019", "4242 - 2020", "32423 - 2021"],
    },
    {
      "subjectCode": "105",
      "subjectName": "DSA",
      "papers": ["2332 - 2023", "3232 - 2023", "5454 - 2022", "2343 - 2022"],
    },
  ];

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Papers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                searchController.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(fontSize: 18),
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Search paper',
                hintText: 'Search by subject code or subject name',
                prefixIcon: const Icon(CupertinoIcons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(CupertinoIcons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: papers.length,
              itemBuilder: (context, index) {
                final subject = papers[index];
                String query = searchController.text.toLowerCase();

                // Check if the search query matches either subject code or subject name
                bool matches = subject["subjectCode"].toLowerCase().contains(query) ||
                    subject["subjectName"].toLowerCase().contains(query);

                if (!matches) {
                  return const SizedBox(); // Return an empty widget if no match
                }

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF193238),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${subject["subjectCode"]} - ${subject["subjectName"]}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subject["papers"].length,
                        separatorBuilder: (context, _) => const Divider(),
                        itemBuilder: (context, paperIndex) {
                          final paper = subject["papers"][paperIndex];
                          return ListTile(
                            title: Text(
                              paper,
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _launchURL(
                                  "https://drive.google.com/file/d/1-Fq2-gLXddEj0eEu8cWoLoC8bgidScw1/view?usp=sharing"),
                              child: const Text("View"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

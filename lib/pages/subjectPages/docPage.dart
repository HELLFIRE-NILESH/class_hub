import 'package:class_hub/api_data/dataLoaders.dart';
import 'package:class_hub/api_data/dataRefresher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class docPage extends StatefulWidget {
  final int subjectId;
  const docPage({super.key, required this.subjectId});

  @override
  State<docPage> createState() => _docPageState();
}

class _docPageState extends State<docPage> {
  List<Map<String, dynamic>> sites = [];
  bool isRefreshing = true;
  Map<String, List<Map<String, dynamic>>> groupedSites = {};

  @override
  void initState() {
    super.initState();
    downloadLoader(widget.subjectId).then((data) {
      setState(() {
        isRefreshing = false;
        sites = data;

        groupedSites = _groupSitesByTitle(sites);
      });
    }).catchError((error) {
      setState(() {
        isRefreshing = false;
      });
      print('Error fetching Sites: $error');
    });
  }

  // Group sites by their title
  Map<String, List<Map<String, dynamic>>> _groupSitesByTitle(List<Map<String, dynamic>> sites) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var site in sites) {
      String title = site['type'];
      if (grouped.containsKey(title)) {
        grouped[title]?.add(site);
      } else {
        grouped[title] = [site];
      }
    }

    return grouped;
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch $url: $e');
    }
  }


  void refresh() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      await refreshData(context,widget.subjectId.toString(),"downloads");
      await downloadLoader(widget.subjectId).then((data)=>{
        setState(() {
          sites = data;
          groupedSites = _groupSitesByTitle(sites);
          isRefreshing = false;
        })
      });

    } catch (error) {
      setState(() {
        isRefreshing =
        false;
      });
      print('Error refreshing assignments: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents - ${widget.subjectId}"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                refresh();
              },
            ),
          ),
        ],
      ),
      body: isRefreshing
          ? Center(child: CircularProgressIndicator())
          : groupedSites.isEmpty
          ? Center(
        child: Text(
          'No sites found for Subject.',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      )
          : ListView.builder(
        itemCount: groupedSites.keys.length,
        itemBuilder: (context, index) {
          String title = groupedSites.keys.elementAt(index);
          List<Map<String, dynamic>> groupedSiteList = groupedSites[title]!;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Card(


              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFF193238),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white

                        ),
                      ),
                    ),
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                        thickness: 2,
                      );
                    },
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: groupedSiteList.length,
                    itemBuilder: (context, innerIndex) {
                      final site = groupedSiteList[innerIndex];

                      return GestureDetector(
                        onTap: () {
                          _launchURL(site['link']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      site['detail'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        wordSpacing: 2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => _launchURL(site['link']),
                                child: Text("View"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

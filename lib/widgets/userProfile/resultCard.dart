import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SGPACGPASection extends StatelessWidget {
  final List<dynamic> sgpa;
  final List<dynamic> link;

  static const Color primaryColor = Color(0xFF193238);
  static const Color accentColor = Color(0xFF00796B);

  const SGPACGPASection({super.key, required this.sgpa, required this.link});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 40;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Results",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // SGPA List with Stylish Buttons
              ...List.generate(sgpa.length, (index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Semester label
                          Text(
                            "Semester ${index + 1}:",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            sgpa[index].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Stylish Button
                          ElevatedButton.icon(
                            onPressed: () {
                              if (index < link.length && link[index].isNotEmpty) {
                                _launchURL(link[index]);
                              } else {
                                debugPrint(
                                    "Invalid or missing URL for Semester ${index + 1}");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                            ),
                            icon: const Icon(Icons.visibility,
                                size: 18, color: Colors.white),
                            label: const Text(
                              "View",
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

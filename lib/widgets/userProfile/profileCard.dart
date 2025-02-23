import 'package:class_hub/theme/themeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onImageTap;
  final String name;
  final String? dp;
  final String mobile;
  final String branch;
  final String rollNumber;
  final int semester;

  static const Color primaryColor = Color(0xFF193238);

  const ProfileSection({
    super.key,
    required this.isExpanded,
    required this.onImageTap,
    required this.name,
    required this.mobile,
    required this.branch,
    required this.rollNumber,
    required this.semester,
    this.dp,
  });

  String getSemesterSuffix(int semester) {
    if (semester % 10 == 1 && semester != 11) {
      return 'st';
    } else if (semester % 10 == 2 && semester != 12) {
      return 'nd';
    } else if (semester % 10 == 3 && semester != 13) {
      return 'rd';
    } else {
      return 'th';
    }
  }

  void copy(BuildContext context, String roll) {
    Clipboard.setData(ClipboardData(text: roll));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Roll Number copied!"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 40;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onImageTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: isExpanded ? 250 : 120,
                  height: isExpanded ? 250 : 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(isExpanded ? 20 : 60),
                    border: Border.all(color: MyTheme.primaryColor),
                  ),
                  child: dp != null && dp!.isNotEmpty
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(isExpanded ? 20 : 60),
                          child: CachedNetworkImage(
                            imageUrl: dp!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Placeholder()
                          ),
                        )
                      : Placeholder()
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                mobile,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$branch, $semester${getSemesterSuffix(semester)} Sem ",
                style: const TextStyle(
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => copy(context, rollNumber),
                child: Text(
                  rollNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

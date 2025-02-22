import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onImageTap;
  final String name;
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
      const SnackBar(content: Text("Roll Number copied!"),duration: Duration(seconds: 1),),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 40;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
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
                    image: DecorationImage(image: AssetImage("assets/images/profilepic.png")),
                    borderRadius: BorderRadius.circular(isExpanded ? 20 : 60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style:Theme.of(context).textTheme.titleLarge
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  GestureDetector(
                    onTap: () {
                      copy(context, rollNumber);
                    },
                    child: Text(
                      rollNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // IconButton(onPressed: () {
                  //   copy(context,rollNumber);
                  // }, icon: Icon(CupertinoIcons.doc_on_clipboard))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

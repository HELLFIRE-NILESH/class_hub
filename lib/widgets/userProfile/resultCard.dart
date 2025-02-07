import 'package:flutter/material.dart';

class SGPACGPASection extends StatelessWidget {
  final List<dynamic> sgpa;
  static const Color primaryColor = Color(0xFF193238);


  const SGPACGPASection({super.key, required this.sgpa});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 40;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),  // Slightly rounded corners
        ),
        color: Colors.white,  // Clean white background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SGPA Heading with Nunito font
               Text(
                "SGPA",
                style: Theme.of(context).textTheme.titleLarge
        ),
              const SizedBox(height: 12),

              // SGPA List
              ...List.generate(sgpa.length, (index) {
                return Column(
                  children: [
                    // Semester label and SGPA value aligned to the right
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Align results to the right
                        children: [
                          // Semester label
                          Text(
                            "Semester ${index + 1}:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            sgpa[index].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00796B),  // Accent color for the SGPA
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index != sgpa.length - 1)
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
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

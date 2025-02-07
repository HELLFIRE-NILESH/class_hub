import 'package:class_hub/theme/themeData.dart';
import 'package:flutter/material.dart';



Widget buildCard(BuildContext context, String title, IconData icon, Widget destinationPage) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationPage),
      );
    },
    child: Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyTheme.buttonColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF193238), width: 1.5),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Center both icon and text
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: MyTheme.primaryColor,
              size: 50,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}

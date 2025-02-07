import 'package:flutter/material.dart';

class appCredit extends StatefulWidget {
  const appCredit({super.key});

  @override
  State<appCredit> createState() => _appCreditState();
}

class _appCreditState extends State<appCredit> {
  static const Color accentColor = Color(0xFF193238); // Your accent color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Credit", style: TextStyle(          fontFamily: "Merri",
        )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile_picture.png'), // Add your profile image here
              ),
            ),
            SizedBox(height: 20),

            // Developer Info
            Text(
              'App Developed By:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontFamily: "Merri",
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nilesh Prajapat',
              style: TextStyle(fontSize: 18,           fontFamily: "Merri",
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Roll No: 22113C04033',
              style: TextStyle(fontSize: 16,           fontFamily: "Merri",
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Batch: 2022 - 25',
              style: TextStyle(fontSize: 16,          fontFamily: "Merri",
              ),
            ),
            SizedBox(height: 20),

            // Technologies Used Section
            Text(
              'Technologies Used:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontFamily: "Merri",
              ),
            ),
            SizedBox(height: 10),
            Text(
              '• Flutter - Framework for building the UI and app functionality.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Node.js - Backend server for handling requests and logic.',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ),
            ),
            Text(
              '• MongoDB - Database for storing app data.',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Text(
              'About the Developer:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontFamily: 'Nunito', // Apply Nunito font
              ),
            ),
            SizedBox(height: 10),
            Text(
              'I built this app as part of my major project in the 6th semester of my Computer Science degree. '
                  'It allowed me to apply my skills in mobile app development, backend technologies, and database management to create a functional and user-friendly application.',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ),
            ),
            SizedBox(height: 20),

            // Contact Information Section
            Text(
              'Contact Information:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontFamily: "Merri",
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email: work.nilesh.pr@gmail.com',
              style: TextStyle(fontSize: 16,           fontFamily: "Merri",
              ),
            ),
            Text(
              'GitHub: github.com/hellfire-nilesh',
              style: TextStyle(fontSize: 16,           fontFamily: "Merri",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

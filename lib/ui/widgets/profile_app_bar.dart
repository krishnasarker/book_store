import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/app_screen/update_profile_screen.dart';
import '../screens/authen/sign_in_screen.dart';
import '../utility/app_color.dart';

AppBar profileAppBar(BuildContext context, [bool fromUpdateProfile = false]) {
  final User? user = FirebaseAuth.instance.currentUser;

  // Extracting first name from display name
  String firstName = '';
  if (user != null && user.displayName != null) {
    List<String> nameParts = user.displayName!.split(' ');
    print('Display Name: ${user.displayName}');
    if (nameParts.isNotEmpty) {
      firstName = nameParts[0];
      print('Extracted First Name: $firstName');
    }
  }

  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: GestureDetector(
      onTap: () {
        if (!fromUpdateProfile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(userId: ''),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.grey[200],
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null, // Display user's profile photo if available
          child: user?.photoURL == null
              ? Icon(Icons.account_circle, size: 40, color: Colors.grey[800]) // Default icon
              : null, // Show default icon if no photo URL
        ),
      ),
    ),
    title: GestureDetector(
      onTap: () {
        if (!fromUpdateProfile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(userId: ''),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello! $firstName',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            user?.email ?? 'No Email',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
          );
        },
        icon: const Icon(Icons.logout, color: Colors.white),
      ),
    ],
  );
}

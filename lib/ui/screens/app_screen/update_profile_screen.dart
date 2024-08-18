import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String _photoURL = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final userData = docSnapshot.data() as Map<String, dynamic>;

    setState(() {
      _firstNameController.text = userData['first_name'] ?? '';
      _lastNameController.text = userData['last_name'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _mobileController.text = userData['mobile'] ?? '';
      _photoURL = userData['photo_url'] ?? user.photoURL ?? ''; // Set photo URL
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: const Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _photoURL.isNotEmpty
                    ? NetworkImage(_photoURL)
                    : null, // Display profile photo if available
                child: _photoURL.isEmpty
                    ? Icon(Icons.account_circle, size: 100, color: Colors.grey[800]) // Default icon
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              readOnly: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              readOnly: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: 'Mobile'),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}

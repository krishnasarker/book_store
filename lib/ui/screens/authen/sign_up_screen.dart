import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_store/ui/screens/main_app_screen_design/main_bottom_nav_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:book_store/ui/utility/app_color.dart';
import 'package:book_store/ui/utility/app_constants.dart';
import 'package:book_store/ui/widgets/background_widgets.dart';
import 'package:book_store/ui/widgets/centered_progress_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _signUpInProgress = false;
  File? _profileImage;

  String email = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String password = "";

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadProfileImage() async {
    if (_profileImage == null) return '';

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(_profileImage!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Failed to upload profile image: $e");
      return '';
    }
  }

  Future<void> SignUpUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _signUpInProgress = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTEController.text,
        password: _passwordTEController.text,
      );

      // Upload profile image and get the URL
      final profileImageUrl = await _uploadProfileImage();

      // Update the user's profile with their name and profile photo
      User? user = userCredential.user;
      if (user != null) {
        await user.updateProfile(
          displayName: '${firstName.toString()} ${lastName.toString()}',
          photoURL: profileImageUrl,
        );
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainBottomNavScreen(user: user),
        ),
      );
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _signUpInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text('Join With Us', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[800])
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value!) == false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (value) {
                        firstName = value;
                      },
                      controller: _firstNameTEController,
                      decoration: const InputDecoration(hintText: 'First Name'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (value) {
                        lastName = value;
                      },
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(hintText: 'Last Name'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (value) {
                        phone = value;
                      },
                      controller: _mobileTEController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Mobile'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your mobile';
                        }
                        if (AppConstants.mobileRegExp.hasMatch(value!) == false) {
                          return 'Enter a valid mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: !_showPassword,
                      controller: _passwordTEController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword ? Icons.remove_red_eye : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: !_signUpInProgress,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: SignUpUser,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _buildBackToSignInSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInSection() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          text: "Have account?",
          children: [
            TextSpan(
              text: 'Sign in',
              style: const TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

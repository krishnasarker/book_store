import 'package:book_store/ui/screens/authen/sign_up_screen.dart';
import 'package:book_store/ui/widgets/centered_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:book_store/ui/utility/app_color.dart';
import 'package:book_store/ui/utility/app_constants.dart';
import 'package:book_store/ui/utility/asset_paths.dart';
import 'package:book_store/ui/widgets/background_widgets.dart';
import 'package:book_store/ui/screens/main_app_screen_design/main_bottom_nav_screen.dart';
import 'email_verification_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  void SignInUser() async{
    final user =await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTEController.text, password: _passwordTEController.text);
    if (user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  MainBottomNavScreen(user:user),
          ));
    } else {
      print("Error");
    }
  }

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _showPassword = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _signInInProgress = false;

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
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage(AssetPaths.loginTheme),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Sign In to Continue',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value!) ==
                            false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      obscureText: _showPassword == false,
                      controller: _passwordTEController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            _showPassword = !_showPassword;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          icon: Icon(_showPassword
                              ? Icons.remove_red_eye
                              : Icons.visibility_off),
                        ),
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _onTapForgotPasswordButton,
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Visibility(
                      visible: _signInInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: SignInUser,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Center(
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                                text: "Don't have a Account?",
                                children: [
                                  TextSpan(
                                    text: 'Sign up',
                                    style: const TextStyle(
                                        color: AppColors.themeColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _onTapSignUpButton,
                                  )
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _onTapNextButton() {
  //   if (_formKey.currentState!.validate()) {
  //     _onTapButton();
  //   }
  // }
  //
  // void _onTapButton() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const MainBottomNavScreen(),
  //     ),
  //   );
  // }

  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}

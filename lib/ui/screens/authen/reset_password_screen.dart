import 'package:book_store/ui/screens/authen/sign_in_screen.dart';
import 'package:book_store/ui/widgets/centered_progress_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utility/app_color.dart';
import '../../widgets/background_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  bool _showPassword = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _resetPasswordInProgress = false;


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
                      height: 80,
                    ),
                    Text(
                      'Set Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Minimum length password 8 character with, Latter and number combination',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      obscureText: _showPassword == false,
                      controller: _newPasswordTEController,
                      decoration: InputDecoration(
                        hintText: 'New Password',
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
                          return 'Enter New Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      obscureText: _showPassword == false,
                      controller: _confirmPasswordTEController,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
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
                          return 'Enter Confirm Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: _resetPasswordInProgress==false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapNextButton,
                        child: const Text('Confirm')
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Center(
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
                                style:
                                    const TextStyle(color: AppColors.themeColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSignInButton,
                              )
                            ]),
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

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _onTapConfirmationButton();
    }
  }

  void _onTapConfirmationButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
            (route) => false);
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
            (route) => false);
  }


  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}

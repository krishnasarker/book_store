import 'package:book_store/ui/screens/authen/reset_password_screen.dart';
import 'package:book_store/ui/screens/authen/sign_in_screen.dart';
import 'package:book_store/ui/widgets/centered_progress_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utility/app_color.dart';
import '../../widgets/background_widgets.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _pinVerificationInProgress = false;

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
                      'Pin Verification',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'A 6 digit verification pin will sent to your email address',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    _buildPinCodeTextField(),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: _pinVerificationInProgress==false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapNextButton,
                        child: const Text('Verify'),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    _buildSignInSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
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
              )
            ]),
      ),
    );
  }

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.themeColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      keyboardType: TextInputType.number,
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
      validator: (String? value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Enter Correct! OTP Number';
        }
        return null;
      },
    );
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _onTapOTPButton();
    }
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (route) => false);
  }

  void _onTapOTPButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPasswordScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _pinTEController.dispose();
    super.dispose();
  }
}

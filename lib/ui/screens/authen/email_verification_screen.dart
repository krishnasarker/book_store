import 'package:book_store/ui/screens/authen/pin_verification_screen.dart';
import 'package:book_store/ui/widgets/centered_progress_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../utility/app_color.dart';
import '../../utility/app_constants.dart';
import '../../utility/asset_paths.dart';
import '../../widgets/background_widgets.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _emailVerificationInProgress = false;

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
                            image: AssetImage(AssetPaths.emailPng),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Your Email Address',
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
                      height: 16,
                    ),
                    Visibility(
                      visible: _emailVerificationInProgress==false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapNextButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PinVerificationScreen()));
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }


  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}

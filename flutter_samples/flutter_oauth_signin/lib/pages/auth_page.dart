// ignore_for_file: use_build_context_synchronously, public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../widgets/animated_error_widget.dart';
import '../services/auth_service.dart';

/// Helper class to show a snackbar using the passed context.
class ScaffoldSnackbar {
  ScaffoldSnackbar(this._context);

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  final BuildContext _context;

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          width: 400,
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

/// Entrypoint example for various sign-in flows with Firebase.
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final authService = AuthService.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';

  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void resetError() {
    if (error.isNotEmpty) {
      setState(() {
        error = '';
      });
    }
  }

  Future<void> _googleSignIn() async {
    resetError();

    try {
      setIsLoading();
      await authService.googleSignIn();
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '${e.message}';
      });
    } finally {
      setIsLoading();
    }
  }

  Future<void> _twitterSignIn() async {
    resetError();

    try {
      setIsLoading();
      await authService.twitterSignIn();
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '${e.message}';
      });
    } finally {
      setIsLoading();
    }
  }

  Future<void> _facebookSignIn() async {
    resetError();

    try {
      setIsLoading();
      await authService.facebookSignIn();
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '${e.message}';
      });
    } finally {
      setIsLoading();
    }
  }

  Future<void> _githubSignIn() async {
    resetError();

    try {
      setIsLoading();
      await authService.githubSignIn();
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '${e.message}';
      });
    } finally {
      setIsLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SizedBox(
                width: 400,
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedError(text: error, show: error.isNotEmpty),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      ...AppOAuthProvider.values.map((provider) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: SignInButton(
                              provider.button,
                              onPressed: () {
                                if (!isLoading) {
                                  switch (provider) {
                                    case AppOAuthProvider.google:
                                      _googleSignIn();
                                      break;
                                    case AppOAuthProvider.facebook:
                                      _facebookSignIn();
                                      break;
                                    case AppOAuthProvider.twitter:
                                      _twitterSignIn();
                                      break;
                                    case AppOAuthProvider.github:
                                      _githubSignIn();
                                      break;
                                  }
                                }
                              },
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.8),
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}

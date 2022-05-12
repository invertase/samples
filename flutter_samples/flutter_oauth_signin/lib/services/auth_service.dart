import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/facebook.dart';
import 'package:desktop_webview_auth/github.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:desktop_webview_auth/twitter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

const _redirectUri =
    'https://react-native-firebase-testing.firebaseapp.com/__/auth/handler';
const _googleClientId =
    '448618578101-sg12d2qin42cpr00f8b0gehs5s7inm0v.apps.googleusercontent.com';
const _twitterApiKey = 'YEXSiWv5UeCHyy0c61O2LBC3B';
const _twitterApiSecretKey =
    'DOd9dCCRFgtnqMDQT7A68YuGZtvcO4WP1mEFS4mEJAUooM4yaE';
const _facebookClientId = '128693022464535';
const _githubClientId = '582d07c80a9afae77406';
const _githubClientSecret = '2d60f5e850bc178dfa6b7f6c6e37a65b175172d3';

/// The different OAuth providers available in this app.
enum AppOAuthProvider {
  google,
  facebook,
  twitter,
  github,
}

extension Button on AppOAuthProvider {
  Buttons get button {
    switch (this) {
      case AppOAuthProvider.google:
        return Buttons.Google;
      case AppOAuthProvider.facebook:
        return Buttons.Facebook;
      case AppOAuthProvider.twitter:
        return Buttons.Twitter;
      case AppOAuthProvider.github:
        return Buttons.GitHub;
    }
  }
}

/// Provide authentication services with [FirebaseAuth].
class AuthService {
  AuthService._();
  static AuthService instance = AuthService._();

  final _auth = FirebaseAuth.instance;

  Stream<User?> authState() {
    return _auth.authStateChanges();
  }

  Future<void> googleSignIn() async {
    String? accessToken;
    String? idToken;

    try {
      // Handle login by a third-party provider based on the platform.
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
        case TargetPlatform.android:
          break;
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          {
            final result = await DesktopWebviewAuth.signIn(
              GoogleSignInArgs(
                clientId: _googleClientId,
                redirectUri: _redirectUri,
                scope: 'https://www.googleapis.com/auth/userinfo.email',
              ),
            );

            idToken = result?.idToken;
            accessToken = result?.accessToken;
          }
          break;
        default:
      }

      if (accessToken != null && idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          idToken: idToken,
          accessToken: accessToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      } else {
        return;
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> twitterSignIn() async {
    String? tokenSecret;
    String? accessToken;

    try {
      // Handle login by a third-party provider based on the platform.
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
        case TargetPlatform.android:
          break;
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          {
            final result = await DesktopWebviewAuth.signIn(
              TwitterSignInArgs(
                apiKey: _twitterApiKey,
                apiSecretKey: _twitterApiSecretKey,
                redirectUri: _redirectUri,
              ),
            );

            tokenSecret = result?.tokenSecret;
            accessToken = result?.accessToken;
          }
          break;
        default:
      }

      if (tokenSecret != null && accessToken != null) {
        // Create a new credential
        final credential = TwitterAuthProvider.credential(
          secret: tokenSecret,
          accessToken: accessToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      } else {
        return;
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> facebookSignIn() async {
    try {
      // Handle login by a third-party provider.
      final result = await DesktopWebviewAuth.signIn(
        FacebookSignInArgs(
          clientId: _facebookClientId,
          redirectUri: _redirectUri,
        ),
      );

      if (result != null) {
        // Create a new credential
        final credential = FacebookAuthProvider.credential(result.accessToken!);

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      } else {
        return;
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> githubSignIn() async {
    try {
      // Handle login by a third-party provider.
      final result = await DesktopWebviewAuth.signIn(
        GitHubSignInArgs(
          clientId: _githubClientId,
          clientSecret: _githubClientSecret,
          redirectUri: _redirectUri,
        ),
      );

      if (result != null) {
        // Create a new credential
        final credential = GithubAuthProvider.credential(result.accessToken!);

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      } else {
        return;
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  /// Sign the Firebase user out.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

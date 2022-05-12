import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/facebook.dart';
import 'package:desktop_webview_auth/github.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:desktop_webview_auth/twitter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

const _redirectUri = 'YOUR_PROJECT_REDIRECT_URI';
const _googleClientId = 'PASTE_YOUR_CLIENT_ID';
const _twitterApiKey = 'PASTE_YOUR_TWITTER_API_KEY';
const _twitterApiSecretKey = 'PASTE_YOUR_TWITTER_API_KEY_SECRET';
const _facebookClientId = 'PASTE_YOUR_CLIENT_ID';
const _githubClientId = 'PASTE_YOUR_GITHUB_CLIENT_ID';
const _githubClientSecret = 'PASTE_YOUR_GITHUB_CLIENT_SECRET';

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

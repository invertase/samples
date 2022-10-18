import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oauth_signin/services/auth_service.dart';

import 'pages/auth_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO uncomment once you generate the options using the FlutterFir eCLI.
  await Firebase.initializeApp(
      options: /* DefaultFirebaseOptions.currentPlatform */ null);

  runApp(const AuthExampleApp());
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class AuthExampleApp extends StatelessWidget {
  const AuthExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example App',
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraines) {
            return Row(
              children: [
                Visibility(
                  visible: constraines.maxWidth >= 1200,
                  child: Expanded(
                    child: Container(
                      height: double.infinity,
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Firebase Auth Desktop',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<User?>(
                    stream: AuthService.instance.authState(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const ProfilePage();
                      }
                      return const AuthPage();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

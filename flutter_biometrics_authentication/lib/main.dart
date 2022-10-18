import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthStatusItem {
  const AuthStatusItem({
    required this.color,
    required this.text,
  });
  final Color color;
  final String text;
}

enum AuthStatus {
  idle(AuthStatusItem(color: Colors.blueGrey, text: 'Not started')),
  success(AuthStatusItem(color: Colors.green, text: 'Successful!')),
  failed(AuthStatusItem(color: Colors.red, text: 'Failed!'));

  final AuthStatusItem value;
  const AuthStatus(this.value);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthView(),
    );
  }
}

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  /// The platform channel used to communicate with the native code.
  /// The namee of the method channel MUST match the name of the channel
  /// defined on the native side.
  final platform = const MethodChannel('samples.invertase.io/biometrics');

  /// The current authentication status.
  AuthStatus authStatus = AuthStatus.idle;

  /// If not null, the error message coming from platform.
  String? error;

  Future<void> authenticateWithBiometrics() async {
    AuthStatus authStatus = AuthStatus.idle;
    error = null;

    try {
      await platform.invokeMethod('authenticateWithBiometrics');

      /// Handle the method calls coming from the native side.
      platform.setMethodCallHandler((call) async {
        if (call.method == 'authenticationResult') {
          if (call.arguments ?? false) {
            authStatus = AuthStatus.success;
          } else {
            authStatus = AuthStatus.failed;
          }

          setState(() {
            this.authStatus = authStatus;
          });
        }
      });
    } on PlatformException catch (e) {
      // The type of error coming from native is always [PlatformException].
      setState(() {
        this.authStatus = AuthStatus.failed;
        error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometrics Sample')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Authentication status'),
            Chip(
              label: Text(
                authStatus.value.text,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: authStatus.value.color,
            ),
            TextButton(
              onPressed: authenticateWithBiometrics,
              child: const Text("Sign in"),
            ),
            if (error != null) Text(error!)
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const AuthPage();
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  Future<void> updatePassword() async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is null');
      }
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: oldPasswordController.text,
        ),
      );

      await FirebaseAuth.instance.currentUser
          ?.updatePassword(newPasswordController.text);

      // This will trigger our backend function to send an SMS & WhatsApp message
      // to inform the user of the password change.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'lastPasswordUpdate': DateTime.now()}, SetOptions(merge: true));

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Password updated successfuly!'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      log('$e', name: 'Error', error: e);
    }

    oldPasswordController.clear();
    newPasswordController.clear();
    primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${FirebaseAuth.instance.currentUser!.email}'),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: oldPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Current password',
                    ),
                  ),
                  TextFormField(
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'New password',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: updatePassword,
                  child: const Text('Update'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool askForPhoneNumber = false;

  Future<void> signup() async {
    final form = formKey.currentState;
    if (form?.validate() ?? false) {
      final email = emailController.text;
      final password = passwordController.text;
      final phoneNumber = phoneNumberController.text;
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (credential.user != null) {
          await savePhoneNumberToFirestore(phoneNumber, credential.user!.uid);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          try {
            if (phoneNumberController.text.isEmpty) {
              setState(() {
                askForPhoneNumber = true;
              });
            } else {
              final credential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email, password: password);

              if (credential.user != null) {
                await savePhoneNumberToFirestore(
                    phoneNumber, credential.user!.uid);
              }
            }
          } catch (e) {
            log('$e', name: 'Error', error: e);
          }
        } else {
          log('$e', name: 'Error', error: e);
        }
      } catch (e) {
        log('$e', name: 'Error', error: e);
      }
    }
  }

  Future<void> savePhoneNumberToFirestore(
    String phoneNumber,
    String uid,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'phoneNumber': phoneNumber});
    } catch (e) {
      log('$e', name: 'Error', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Sign up to Story',
                    style: TextStyle(fontSize: 30, color: Colors.amber),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Email is required' : null,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Password is required' : null,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  if (askForPhoneNumber)
                    TextFormField(
                      controller: phoneNumberController,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Phone Number is required'
                          : null,
                      decoration: const InputDecoration(
                        hintText: 'Phone number',
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: signup,
                      child: const Text('Sign up'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

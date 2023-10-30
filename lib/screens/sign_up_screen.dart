//create a sign up screen
import 'package:flutter/material.dart';
import 'dart:io' show File, Platform;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:splitbill/screens/input_phone_number.dart';

const List<String> _scopes = <String>[
  'email',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: Platform.isIOS
      ? '488800823172-db5uh8fjq74gsb88mbcj7q3kmiifbsr6.apps.googleusercontent.com'
      : null,
  //android clientid
  // clientId: '488800823172-3g6vkc18qc4oh2k4364lp39i0156ealb.apps.googleusercontent.com',
  scopes: _scopes,
);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        //todo
      }
    });
  }

  Future<void> _handleSignIn() async {
    try {
      final googleUserAccount = await _googleSignIn.signIn();
      print(googleUserAccount.toString());
      final googleAuth = await googleUserAccount?.authentication;
      if (googleAuth != null) {
        print('this is the id token');
        //write to file

        print(googleAuth.idToken);
        print('this is the access token');
        print(googleAuth.accessToken);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const InputPhoneNumberScreen()),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;

    if (user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          if (_isAuthorized) ...<Widget>[
            // The user has Authorized all required scopes
            const Text('ajs'),
            ElevatedButton(
              child: const Text('REFRESH'),
              onPressed: () => {},
            ),
          ],
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      print("user is null");
      // The user is NOT Authenticated
      return Container(
        margin: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text('Welcome to Billy!',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 25),
            Center(
              child: Column(
                children: [
                  SignInButton(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    Buttons.Google,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: _handleSignIn,
                  ),
                  const SizedBox(height: 5),
                  SignInButton(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    Buttons.Apple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: _handleSignIn,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }
}

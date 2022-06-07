import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:d_view/d_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/presentation/page/home_page.dart';
import 'package:get/get.dart';

import 'register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
      DMethod.printTitle('login', credential.user!.uid);
      DInfo.dialogSuccess('Login Success');
      DInfo.closeDialog(actionAfterClose: () {
        Get.off(() => const HomePage());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        DInfo.dialogError('User Not Found');
      } else if (e.code == 'wrong-password') {
        DInfo.dialogError('Wrong Password');
      } else {
        DInfo.dialogError('Login Failed');
      }
      DMethod.printTitle('Firebase Auth Exception', e.code);
      DInfo.closeDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: Theme.of(context).textTheme.headline4,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerEmail,
              hint: 'Email',
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerPassword,
              hint: 'Password',
            ),
            DView.spaceHeight(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => login(),
                child: const Text('Login'),
              ),
            ),
            DView.spaceHeight(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => RegisterPage());
                },
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:d_view/d_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  register() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
      DMethod.printTitle('register', credential.user!.uid);
      DInfo.dialogSuccess('Register Success');
      DInfo.closeDialog();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        DInfo.dialogError('Weak Password');
      } else if (e.code == 'email-already-in-use') {
        DInfo.dialogError('Account Already Exist');
      } else {
        DInfo.dialogError('Register Failed');
      }
      DMethod.printTitle('Firebase Auth Exception', e.code);
      DInfo.closeDialog();
    } catch (e) {
      DMethod.printTitle('Register Catch', e.toString());
      DInfo.dialogError('Register Failed');
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
              'Register',
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
                onPressed: () => register(),
                child: const Text('Register'),
              ),
            ),
            DView.spaceHeight(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

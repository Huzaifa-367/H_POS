// ignore_for_file: unused_result

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Provider/customer_provider.dart';
import '../Provider/profile_provider.dart';
import '../Screens/Authentication/profile_setup.dart';

final signUpProvider = ChangeNotifierProvider((ref) => SignUpRepo());

class SignUpRepo extends ChangeNotifier {
  String email = '';
  String password = '';

  Future<void> signUp(BuildContext context) async {
    EasyLoading.show(status: 'Registering....');
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        EasyLoading.showSuccess('Successful');
        // ignore: use_build_context_synchronously
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            ref.refresh(profileDetailsProvider);
            ref.refresh(customerProvider);
            return Container();
          },
        );
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileSetup(
              loginWithPhone: false,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError('Failed with Error');
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      EasyLoading.showError('Failed with Error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

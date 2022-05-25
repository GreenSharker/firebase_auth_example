import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth_example/screens/home_screen.dart';
import 'package:firebase_auth_example/utils/color_utils.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("회원가입", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                reusableTextField("이메일 입력", Icons.person_outline, false, _emailTextController),
                const SizedBox(height: 20),
                firebaseButton(context, "인증메일 발송", () {
                  FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text("인증메일이 발송되었습니다.", textAlign: TextAlign.center)));
                    Navigator.of(context).pop();
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

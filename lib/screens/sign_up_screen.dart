import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth_example/screens/home_screen.dart';
import 'package:firebase_auth_example/utils/color_utils.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

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
                reusableTextField("아이디 입력", Icons.person_outline, false, _userNameTextController),
                const SizedBox(height: 20),
                reusableTextField("이메일 입력", Icons.person_outline, false, _emailTextController),
                const SizedBox(height: 20),
                reusableTextField("비밀번호 입력", Icons.lock_outline, true, _passwordTextController),
                const SizedBox(height: 20),
                firebaseButton(context, "회원가입", () {
                  FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((value) {
                    print("새로운 계정이 생성되었습니다.");
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("에러: ${error.toString()}");
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth_example/screens/home_screen.dart';
import 'package:firebase_auth_example/screens/reset_password_screen.dart';
import 'package:firebase_auth_example/screens/sign_up_screen.dart';
import 'package:firebase_auth_example/services/firebase_service.dart';
import 'package:firebase_auth_example/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.width * 0.2, 20, 0),
            child: Column(
              children: [
                logoWidget("assets/images/logo1.png"),
                const SizedBox(height: 30),
                reusableTextField("이메일 입력", Icons.person_outline, false, _emailTextController),
                const SizedBox(height: 20),
                reusableTextField("비밀번호 입력", Icons.lock_outline, true, _passwordTextController),
                const SizedBox(height: 10),
                forgetPassword(context),
                firebaseButton(context, "로그인", () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((value) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("에러: ${error}")));
                  });
                }),
                signUpOption(),
                const SizedBox(height: 20),
                signInForGoogle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("신규 사용자이신가요?", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text("  회원가입", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "비밀번호를 잊으셨습니까?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ResetPasswordScreen())),
      ),
    );
  }

  Widget signInForGoogle() {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/google.png", width: 30, height: 30),
            const SizedBox(width: 10),
            const Text("구글 로그인", style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      onPressed: () async {
        final _googleSignIn = GoogleSignIn();

        try {
          final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

          if (googleSignInAccount != null) {
            final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
            final AuthCredential authCredential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );

            await FirebaseAuth.instance.signInWithCredential(authCredential).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${googleSignInAccount.displayName}님, 환영합니다.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
            });
          }
        } on FirebaseAuthException catch (e) {
          print(e.message);
          throw e;
        }
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
    );
  }
}

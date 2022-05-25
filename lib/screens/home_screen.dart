import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/screens/sign_in_screen.dart';
import 'package:firebase_auth_example/services/firebase_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("${FirebaseAuth.instance.currentUser!.displayName}"),
            Text("${FirebaseAuth.instance.currentUser!.email}"),
            Center(
              child: ElevatedButton(
                child: const Text("로그아웃"),
                onPressed: () async {
                  await FirebaseService().signOut();
                  print("성공적으로 로그아웃 되었습니다.");
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

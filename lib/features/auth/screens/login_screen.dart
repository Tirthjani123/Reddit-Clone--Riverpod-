import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';
import '../../../core/common/loader.dart';


class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {


  signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = ref.read(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.logoPath, height: 40,),
        centerTitle: true,
        actions: [
          TextButton(onPressed: () {},
              child: Text("SKIP", style: TextStyle(color: Pallete.blueColor),))
        ],
      ),
      body: isLoading ? const Loader() : SafeArea(
        child: Column(
            children: [
              const SizedBox(height: 30,),
              const Text("Dive into anything", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(Constants.loginEmotePath, height: 400,),
              ),
              const SizedBox(height: 30,),
              Container(
                height: 60,
                width: 300,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await signInWithGoogle(context, ref);
                    setState(() {});
                  },
                  icon: Image.asset(
                    Constants.googleImagePath,
                    height: 30,
                  ),
                  label: Text(
                    "Continue With Google",
                    style: TextStyle(color: Pallete.blueColor, fontSize: 18),
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';

class SignInButton extends ConsumerWidget {
  SignInButton({super.key});

    signInWithGoogle(BuildContext context ,WidgetRef ref) {
      ref.read(authControllerProvider.notifier).signInWithGoogle(context);
    }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      width: 300,
      child: ElevatedButton.icon(
        onPressed: () async{
          await signInWithGoogle(context, ref);
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
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/repositories/auth_repository.dart';
import 'package:reddit_clone/features/home/screen/home_screen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/utils.dart';
import '../../models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authStateChangedProvider = StreamProvider((ref){
  final authStateChanged = ref.watch(authControllerProvider.notifier);
  return authStateChanged.authStateChanged;
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref),
);

final getUserDataProvider = StreamProvider.family((ref,String uid){
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository authRepository;
  final Ref ref;

  Stream<User?> get authStateChanged => authRepository.authStateChanged;

  AuthController({required this.ref, required this.authRepository})
      : super(false); // loading

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await authRepository.signInWithGoogle();
    state = false;
    user.fold(
          (l) => showSnackBar(context, l.message),
          (userModel) {
            ref.read(userProvider.notifier).update((state) => userModel);
          }
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return authRepository.getUserData(uid);
  }


  void logOut()async{
    authRepository.logOut();
  }
}

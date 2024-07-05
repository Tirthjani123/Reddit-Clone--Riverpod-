import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';
import 'package:reddit_clone/features/models/user_model.dart';
import 'package:riverpod/riverpod.dart';

import '../../../core/type_def.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firebaseFirestore: ref.read(fireStoreProvider),
    firebaseAuth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider)));



class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firebaseFirestore,
      required FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firebaseFirestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanged => _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      UserModel userModel;
      if(userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            name: userCredential.user?.displayName.toString() ?? 'No Name',
            profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: []
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      }else{
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    }on FirebaseException catch (e){
      print(e.toString());
      throw e.message!;
    }
    catch (e) {
      print(e.toString());
      return left(Failure(e.toString()));
    }
  }


  Stream<UserModel> getUserData(String uid){
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String,dynamic>));
  }


  void logOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}

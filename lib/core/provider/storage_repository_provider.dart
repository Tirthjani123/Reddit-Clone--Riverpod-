import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';

final  storageRepositoryProvider = Provider((ref) => StorageRepository(ref.watch(firebaseStorageProvider)));

class StorageRepository{
  final FirebaseStorage _firebasestorage;

  StorageRepository(this._firebasestorage);

  FutureEither<String> storeFile({required String id,required String path,required File? file}) async {
    try{
      final ref = _firebasestorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    }catch(e){
      return left(Failure(e.toString()));
    }
  }
}
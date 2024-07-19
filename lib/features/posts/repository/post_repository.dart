import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';

import '../../../core/failure.dart';
import '../../../core/type_def.dart';
import '../../models/community.dart';
import '../../models/post_model.dart';

final postRepositoryProvider = Provider((ref) => PostRepository(
      firebasefirestore: ref.watch(fireStoreProvider),
    ));

class PostRepository {
  final FirebaseFirestore _firebasefireStore;

  PostRepository({required FirebaseFirestore firebasefirestore})
      : _firebasefireStore = firebasefirestore;

  CollectionReference get _posts =>
      _firebasefireStore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
}

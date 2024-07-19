import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/models/community.dart';
import 'package:reddit_clone/features/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/provider/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../repository/post_repository.dart';


final postControllerProvider =
StateNotifierProvider<PostController, bool>((ref) {
  final postRepository  = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
      postRepository: postRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final userPostProvider = StreamProvider.family((ref,List<Community> communities){
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPost(communities);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({required String tittle,
    required BuildContext context,
    required Community selectedCommunity,
    required String desription}) async {
    state = true;
    String postId = const Uuid().v4.toString();
    final user = _ref.watch(userProvider)!;
    final Post post = Post(
        id: postId,
        title: tittle,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: desription);
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) =>
        showSnackBar(
            context,
            l.message
        ), (r) {
      showSnackBar(context, 'Posted Successfully');
      Routemaster.of(context).pop();
    });
  }
  void shareLinkPost({required String tittle,
    required BuildContext context,
    required Community selectedCommunity,
    required String link}) async {
    state = true;
    String postId = const Uuid().v4.toString();
    final user = _ref.watch(userProvider)!;
    final Post post = Post(
        id: postId,
        title: tittle,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        link: link);
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) =>
        showSnackBar(
            context,
            l.message
        ), (r) {
      showSnackBar(context, 'Posted Successfully');
      Routemaster.of(context).pop();
    });
  }
  void shareImagePost({required String tittle,
    required BuildContext context,
    required Community selectedCommunity,
    required File? file}) async {
    state = true;
    String postId = const Uuid().v1.toString();
    final user = _ref.watch(userProvider)!;
    final imageRes = await _storageRepository.storeFile(id: postId, path: 'posts/${selectedCommunity.name}',file: file);
    imageRes.fold((l) => showSnackBar(context, l.message), (r) async{
      final Post post = Post(
          id: postId,
          title: tittle,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'text',
          createdAt: DateTime.now(),
          awards: [],
          link:r);
      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) =>
          showSnackBar(
              context,
              l.message
          ), (r) {
        showSnackBar(context, 'Posted Successfully');
        Routemaster.of(context).pop();
      });
    });
  }
  Stream<List<Post>> fetchUserPost(List<Community> communities){
    if(communities.isNotEmpty){
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }
}

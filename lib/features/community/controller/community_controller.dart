import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repositories/community_repositories.dart';
import 'package:reddit_clone/features/models/community.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/type_def.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunity();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref
      .watch(communityControllerProvider.notifier)
      .searchCommunity(query);
});
final communityControllerProvider =
StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
      communityRepository: communityRepository,
      ref: ref,
      storageRepository: storageRepository);
});

class CommunityController extends StateNotifier<bool> {
  final _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController({required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Future<void> createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref
        .read(userProvider)
        ?.uid ?? '';
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);
    final res = await _communityRepository.createCommunity(community);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community Successfully Created!');
      Routemaster.of(context).pop();
    });
    state = false;
  }

  void editCommunity({required Community community,
    required File? profileFile,
    required BuildContext context,
    required File? bannerFile}) async {
    if (profileFile != null) {
      state= true;
      final res = await _storageRepository.storeFile(
          id: community.name, path: 'communities/profile', file: profileFile);
      res.fold((l) => showSnackBar(context, l.message), (r) =>
      community = community.copyWith(avatar: r));
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          id: community.name, path: 'communities/banner', file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message), (r) =>
      community = community.copyWith(banner: r));
    }
    final res = await _communityRepository.editCommunity(community);
    res.fold((l)=>showSnackBar(context, l.message),(r)=>Routemaster.of(context).pop());
    state = false;
  }

  Future<void> joinCommunity(Community community,BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure,void> res;
    if(community.members.contains(user.uid)){
      res = await _communityRepository.leaveCommunity(community.name,user.uid);
    }else{
      res = await _communityRepository.joinCommunity(community.name,user.uid);
    }
    res.fold((l)=>showSnackBar(context, l.message),(r){
      if(community.members.contains(user.uid)){
        showSnackBar(context, 'Community left Successfully');
      }else{
        showSnackBar(context, 'Community joined Successfully');
      }
    });
  }


  Stream<List<Community>> getUserCommunity() {
    final uid = _ref
        .read(userProvider)
        ?.uid ?? '';
    return _ref.read(communityRepositoryProvider).getUserCommunities(uid);
  }
  Stream<List<Community>> searchCommunity(String query){
    return _communityRepository.searchCommunity(query);
  }
}

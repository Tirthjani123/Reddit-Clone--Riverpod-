import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/models/community.dart';

import '../../../core/constants/constants.dart';
import '../../../theme/pallet.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<EditCommunityScreen> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      bannerFile = File(res.files.first.path!);
    }
    setState(() {});
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      profileFile = File(res.files.first.path!);
    }
    setState(() {});
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
        community: community,
        profileFile: profileFile,
        context: context,
        bannerFile: bannerFile);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => isLoading? const Loader():Scaffold(
              backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
              appBar: AppBar(
                title: const Text('Edit Community'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                        onTap: () {
                          save(community);
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Pallete.blueColor),
                        )),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              selectBannerImage();
                            },
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              dashPattern: [10, 4],
                              radius: Radius.circular(10),
                              color: Colors.white,
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : community.banner.isEmpty ||
                                            community.banner ==
                                                Constants.bannerDefault
                                        ? const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          )
                                        : Image.network('${community.banner}'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: InkWell(
                              onTap: () {
                                selectProfileImage();
                              },
                              child: profileFile != null
                                  ? CircleAvatar(
                                      radius: 32,
                                      backgroundImage: FileImage(profileFile!),
                                    )
                                  : CircleAvatar(
                                      radius: 32,
                                      backgroundImage:
                                          NetworkImage(community.avatar),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => Loader());
  }
}

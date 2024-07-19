// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';
import '../../../core/utils.dart';
import '../../models/community.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  TextEditingController tittleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  File? bannerFile;
  Community? selectedCommunity;
  List<Community> communities = [];

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      bannerFile = File(res.files.first.path!);
    }
    setState(() {});
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        tittleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          tittle: tittleController.text.trim(),
          context: context,
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile);
    } else if (widget.type == 'text' && tittleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          tittle: tittleController.text.trim(),
          context: context,
          selectedCommunity: selectedCommunity ?? communities[0],
          desription: discriptionController.text.trim());
    } else if (widget.type == 'link' && tittleController.text.isNotEmpty && linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          tittle: tittleController.text,
          context: context,
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim());
    }else{
      showSnackBar(context, 'Please enter all fields');
    }
  }

  @override
  void dispose() {
    super.dispose();
    tittleController.dispose();
    discriptionController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postControllerProvider);
    final currTheme = ref.watch(themeNotifierProvider);
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    return isLoading ? Loader() : Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [TextButton(onPressed: sharePost, child: Text('Share'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: tittleController,
              decoration: InputDecoration(
                hintText: 'Enter Tittle here',
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 30,
            ),
            const SizedBox(
              height: 20,
            ),
            if (isTypeImage)
              InkWell(
                onTap: () {
                  selectBannerImage();
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: [10, 4],
                  radius: Radius.circular(10),
                  color: currTheme.textTheme.bodyLarge!.color!,
                  strokeCap: StrokeCap.round,
                  child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: bannerFile != null
                          ? Image.file(bannerFile!)
                          : const Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                            )),
                ),
              ),
            if (isTypeText)
              TextField(
                controller: discriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter Discription here',
                  filled: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            if (isTypeLink)
              TextField(
                controller: linkController,
                decoration: InputDecoration(
                  hintText: 'Enter Discription here',
                  filled: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: AlignmentDirectional.topStart,
                child: Text('Select Community')),
            ref.watch(userCommunitiesProvider).when(
                data: (data) {
                  communities = data;
                  if (data.isEmpty) {
                    return const SizedBox();
                  }
                  return DropdownButton(
                      value: selectedCommunity ?? data[0],
                      items: data
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (val) {
                        selectedCommunity = val;
                        setState(() {});
                      });
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => Loader())
          ],
        ),
      ),
    );
  }
}

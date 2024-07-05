// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import '../../../theme/pallet.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityController.dispose();
  }

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a community'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      child: Text('Community Name'),
                      alignment: AlignmentDirectional.topStart,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: communityController,
                      decoration: InputDecoration(
                        hintText: 'r/Create_community',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 21,
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        createCommunity();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Pallete.blueColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            'Create Community',
                            style: TextStyle(
                                color: Pallete.whiteColor, fontSize: 17),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';
import 'package:routemaster/routemaster.dart';

import '../../models/community.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context,String name) {
    Routemaster.of(context).push('/mods-tools/$name');
  }
    void joinCommunity(Community community,BuildContext context,WidgetRef ref){
    ref.watch(communityControllerProvider.notifier).joinCommunity(community,context);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // status
                Stack(
                  children: [
                      SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Image.network(
                        community.banner,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(community.avatar),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'r/${community.name}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),

                    Spacer(),
                    community.mods.contains(user.uid)?
                    OutlinedButton(
                      onPressed: () {navigateToModTools(context,name);},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                      child: Text(
                        "Mod Tools ",
                        style: TextStyle(color: Pallete.blueColor),
                      ),
                    ):OutlinedButton(
                      onPressed: () {
                        joinCommunity(community, context, ref);
                      },
                      //
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: Text(
                        community.members.contains(user.uid)?"Joined":"Join",
                        style: TextStyle(color: Pallete.blueColor),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${community.members.length} members'),
                ),
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => Loader()),
    );
  }
}

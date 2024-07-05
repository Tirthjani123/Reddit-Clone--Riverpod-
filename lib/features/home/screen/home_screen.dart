// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/home/delegates/search_delegates.dart';
import 'package:reddit_clone/features/home/drawer/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawer/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchCommunityDelegates(ref: ref));
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return  IconButton(
                onPressed: ()=> displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user?.profilePic ?? ''),
                  radius: 15,
                ),
              );
            },
          )
        ],
      ),
      endDrawer: ProfileDrawer(),
      drawer: CommunityListDrawer(),
    );
  }
}

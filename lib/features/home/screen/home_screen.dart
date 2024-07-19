// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/home/delegates/search_delegates.dart';
import 'package:reddit_clone/features/home/drawer/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawer/profile_drawer.dart';
import 'package:reddit_clone/theme/pallet.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
  void inPageChanged(int page){
    setState(() {
      _page = page;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchCommunityDelegates(ref: ref));
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user?.profilePic ?? ''),
                  radius: 15,
                ),
              );
            },
          )
        ],
      ),
      body: Constants.tabWidgets[_page],
      endDrawer: ProfileDrawer(),
      drawer: CommunityListDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: currentTheme.backgroundColor,
        selectedItemColor: currentTheme.iconTheme.color,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: ''),
        ],
        onTap: inPageChanged,
        currentIndex: _page,
      ),
    );
  }
}


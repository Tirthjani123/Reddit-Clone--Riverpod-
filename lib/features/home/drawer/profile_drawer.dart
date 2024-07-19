// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref, BuildContext context) async {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void toggleTheme(WidgetRef ref)async {
    ref.read(themeNotifierProvider.notifier).toggle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage:
                  NetworkImage(user?.profilePic ?? Constants.avatarDefault),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "u/${user?.name ?? Constants.avatarDefault}",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 35,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Profile'),
            ),
            ListTile(
              onTap: () {
                logOut(ref, context);
              },
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              title: Text('Logout'),
            ),
            Switch(
              value: ref.watch(themeNotifierProvider.notifier).getMode()==ThemeMode.dark,
              onChanged: (val) => toggleTheme(ref),
              activeColor: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}

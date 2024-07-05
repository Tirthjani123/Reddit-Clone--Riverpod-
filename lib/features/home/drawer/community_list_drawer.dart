// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/screen/community_screen.dart';
import 'package:reddit_clone/features/community/screen/create_community_screen.dart';
import 'package:reddit_clone/features/models/community.dart';
import 'package:reddit_clone/core/common/loader.dart';

Stream<List<Community>> getUserCommunitiesList(WidgetRef ref) {
  return FirebaseFirestore.instance
      .collection('communities').where('members', arrayContains:ref.watch(userProvider)!.uid).snapshots()
      .map((event) {
    List<Community> communities = [];
    for (var doc in event.docs) {
      communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
    }
    return communities;
  });
}

class CommunityListDrawer extends ConsumerWidget {
  CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    // Routemaster.of(context).push('/create-community');
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateCommunityScreen()));
  }
  void navigateToCommunity(BuildContext context,Community community) {
    // Routemaster.of(context).push('/r/${community.name}');
    Navigator.push(context, MaterialPageRoute(builder: (context)=> CommunityScreen(name: community.name)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build');
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text(
                "Create a community",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () {
                navigateToCreateCommunity(context);
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: getUserCommunitiesList(ref),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader();
                  }
                  if (!snapshot.hasData) {
                    return Text('NO DATA');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 1,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: (){
                          navigateToCommunity(context, snapshot.data![index]);
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot
                                  .data?[index].avatar ??
                              'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2'),
                        ),
                        title: Text('r/${snapshot.data![index].name}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

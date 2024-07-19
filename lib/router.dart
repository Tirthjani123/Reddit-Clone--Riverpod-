import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screen/community_screen.dart';
import 'package:reddit_clone/features/community/screen/create_community_screen.dart';
import 'package:reddit_clone/features/community/screen/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screen/mod_tools_screen.dart';
import 'package:reddit_clone/features/home/screen/home_screen.dart';
import 'package:reddit_clone/features/posts/screen/add_post_screen.dart';
import 'package:reddit_clone/features/posts/screen/add_post_type_screen.dart';
import 'package:routemaster/routemaster.dart';

final logedOutRoute = RouteMap(routes: {
  '/': (_)=>MaterialPage(child: LoginScreen()),
});

final logedInRoute = RouteMap(routes: {
  '/':(_)=>MaterialPage(child: HomeScreen()),
  '/create-community':(_)=>MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route)=>MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!)),
  '/mods-tools/:name': (routeData)=>MaterialPage(child: ModToolsScreen(name: routeData.pathParameters['name']!)),
  '/edit-community/:name': (routeData)=>MaterialPage(child: EditCommunityScreen(name: routeData.pathParameters['name']!)),
  '/add-post/:type': (routeData)=>MaterialPage(child: AddPostTypeScreen(type: routeData.pathParameters['type']!)),

});
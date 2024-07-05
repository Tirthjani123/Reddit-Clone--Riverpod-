import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';


class SearchCommunityDelegates extends SearchDelegate {
  final WidgetRef  ref;
  SearchCommunityDelegates({required this.ref});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query ='';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(data: (communities)=>ListView.builder(
      itemCount: communities.length,

      itemBuilder: (context,index){
        final community = communities[index];
        return ListTile(
          onTap: (){
            Routemaster.of(context).push('/r/${community.name}');
          },
          title: Text('r/${community.name}'),
          leading: CircleAvatar(backgroundImage: NetworkImage(community.avatar),),
        );
      },
    ), error: (error,stackTrace)=>ErrorText(error: error.toString()), loading:()=> const Loader());
  }
}

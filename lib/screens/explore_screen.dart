import 'package:flutter/material.dart';
import 'package:fooderlich/components/today_recipe_list_view.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatefulWidget {
  // 1

  ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final mockService = MockFooderlichService();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  // Challenge task
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('reached the bottom');
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('reached the top!');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is the FutureBuilder from before.
    //It runs an asynchronous task and lets you know the state of the future.
    return FutureBuilder(
      // Use your mock service to call getExploreData().
      //This returns an ExploreData object future.
      future: mockService.getExploreData(),
      // Check the state of the future within the builder callback.
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        // Check if the future is complete.
        if (snapshot.connectionState == ConnectionState.done) {
          // When the future is complete, return the primary ListView.
          //This holds an explicit list of children. In this scenario, the
          //primary ListView will hold the other two ListViews as children.
          return ListView(
            controller: _scrollController,
            // Set the scroll direction to vertical, although that’s
            //the default value.
            scrollDirection: Axis.vertical,
            children: [
              // The first item in children is TodayRecipeListView.
              //You pass in the list of todayRecipes from ExploreData.

              TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
              // Add a 16-point vertical space so the lists aren’t too close to
              //each other.

              const SizedBox(height: 16),
              FriendPostListView(friendPosts: snapshot.data?.friendPosts ?? []),
            ],
          );
        } else {
          // If the future hasn’t finished loading yet, show a
          //circular progress indicator.

          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

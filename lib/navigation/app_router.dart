import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/screens.dart';

// It extends RouterDelegate. The system will tell the router to build and
//configure a navigator widget.
class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  // Declares GlobalKey, a unique key across the entire app.
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // Declares AppStateManager. The router will listen to app state changes to
  //configure the navigator’s list of pages.
  final AppStateManager appStateManager;
  // Declares GroceryManager to listen to the user’s state when you create or
  //edit an item.
  final GroceryManager groceryManager;
  // Declares ProfileManager to listen to the user profile state.
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    // When the state changes, the router will reconfigure the navigator with a
    //new set of pages.

    // appStateManager: Determines the state of the app. It manages whether the
    //app initialized login and if the user completed the onboarding.
    appStateManager.addListener(notifyListeners);
    // groceryManager: Manages the list of grocery items and the item selection
    // state.
    groceryManager.addListener(notifyListeners);
    // profileManager: Manages the user’s profile and settings.
    profileManager.addListener(notifyListeners);
  }

  // When you dispose the router, you must remove all listeners.
  //Forgetting to do this will throw an exception.
  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  // RouterDelegate requires you to add a build(). This configures your
  //navigator and pages.
  @override
  Widget build(BuildContext context) {
    // Configures a Navigator.
    return Navigator(
      // Uses the navigatorKey, which is required to retrieve the
      //current navigator.
      key: navigatorKey,

      // When the user taps the Back button or triggers a system back button
      //event, it fires a helper method, onPopPage. This way, it’s called every
      //time a page pops from the stack.
      onPopPage: _handlePopPage,
      // Declares pages, the stack of pages that describes your navigation stack
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        // TODO: Add LoginScreen
        // TODO: Add OnboardingScreen
        // TODO: Add Home
        // TODO: Create new item
        // TODO: Select GroceryItemScreen
        // TODO: Add Profile Screen
        // TODO: Add WebView Screen
      ],
    );
  }

  bool _handlePopPage(
      // This is the current Route, which contains information like
      //RouteSettings to retrieve the route’s name and arguments.
      Route<dynamic> route,
      // result is the value that returns when the route completes — a value
      //that a dialog returns, for example.
      result) {
    // Checks if the current route’s pop succeeded.
    if (!route.didPop(result)) {
      // If it failed, return false.
      return false;
    }

    // If the route pop succeeds, this checks the different routes and triggers
    //the appropriate state changes.

    // TODO: Handle Onboarding and splash
    // TODO: Handle state when user closes grocery item screen
    // TODO: Handle state when user closes profile screen
    // TODO: Handle state when user closes WebView screen
    // 6
    return true;
  }

  // Sets setNewRoutePath to null since you aren’t supporting Flutter web apps
  //yet. Don’t worry about that for now, you’ll learn more about that topic in
  //the next chapter.
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}

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
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),
        // Checks if the user is creating a new grocery item.
        if (groceryManager.isCreatingNewItem)
          // If so, shows the Grocery Item screen.
          GroceryItemScreen.page(
            onCreate: (item) {
              // Once the user saves the item, updates the grocery list.
              groceryManager.addItem(item);
            },
            onUpdate: (item, index) {
              // onUpdate only gets called when the user updates an existing
              // item. So now it's empty
            },
          ),
        // Checks to see if a grocery item is selected.
        if (groceryManager.selectedIndex != -1)
          // If so, creates the Grocery Item screen page.
          GroceryItemScreen.page(
              item: groceryManager.selectedGroceryItem,
              index: groceryManager.selectedIndex,
              onUpdate: (item, index) {
                // When the user changes and saves an item, it updates the item
                //at the current index.
                groceryManager.updateItem(item, index);
              },
              onCreate: (_) {
                // onCreate only gets called when the user adds a new item.
              }),
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
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

    // If the user taps the Back button from the Onboarding screen, it calls
    //logout(). This resets the entire app state and the user has to log in agai
    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }

    // Handle state if user rejects changes in the grocery item
    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }
    // Handle state when user closes profile screen ???
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }

    // Handle state when user closes WebView screen
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    // 6
    return true;
  }

  // Sets setNewRoutePath to null since you aren’t supporting Flutter web apps
  //yet. Don’t worry about that for now, you’ll learn more about that topic in
  //the next chapter.
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}

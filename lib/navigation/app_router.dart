import 'package:flutter/material.dart';
import 'app_link.dart';

import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) ...[
          SplashScreen.page(),
        ] else if (!appStateManager.isLoggedIn) ...[
          LoginScreen.page(),
        ] else if (!appStateManager.isOnboardingComplete) ...[
          OnboardingScreen.page(),
        ] else ...[
          Home.page(appStateManager.getSelectedTab),
          if (groceryManager.isCreatingNewItem)
            GroceryItemScreen.page(onCreate: (item) {
              groceryManager.addItem(item);
            }, onUpdate: (item, index) {
              // No update
            }),
          if (groceryManager.selectedIndex != -1)
            GroceryItemScreen.page(
                item: groceryManager.selectedGroceryItem,
                index: groceryManager.selectedIndex,
                onCreate: (_) {
                  // No create
                },
                onUpdate: (item, index) {
                  groceryManager.updateItem(item, index);
                }),
          if (profileManager.didSelectUser)
            ProfileScreen.page(profileManager.getUser),
          if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
        ]
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }

    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }

    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }

    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    return true;
  }

  AppLink getCurrentPath() {
    // If the user hasn’t logged in, return the app link with the login path.
    if (!appStateManager.isLoggedIn) {
      return AppLink(location: AppLink.kLoginPath);
      // If the user hasn’t completed onboarding, return the app link with the
      //onboarding path.
    } else if (!appStateManager.isOnboardingComplete) {
      return AppLink(location: AppLink.kOnboardingPath);
      // If the user taps the profile, return the app link with the profile path
    } else if (profileManager.didSelectUser) {
      return AppLink(location: AppLink.kProfilePath);
      // If the user taps the + button to create a new grocery item, return the
      //app link with the item path.
    } else if (groceryManager.isCreatingNewItem) {
      return AppLink(location: AppLink.kItemPath);
      // If the user selected an existing item, return an app link with the item
      //path and the item’s id.
    } else if (groceryManager.selectedGroceryItem != null) {
      final id = groceryManager.selectedGroceryItem?.id;
      return AppLink(location: AppLink.kItemPath, itemId: id);
      // If none of the conditions are met, default by returning to the home
      //path with the selected tab.
    } else {
      return AppLink(
          location: AppLink.kHomePath,
          currentTab: appStateManager.getSelectedTab);
    }
  }

  @override
  AppLink get currentConfiguration => getCurrentPath();

  // You call setNewRoutePath() when a new route is pushed. It passes along an
  //AppLink. This is your navigation configuration.
  @override
  Future<void> setNewRoutePath(AppLink newLink) async {
    // Use a switch to check every location.
    switch (newLink.location) {
      // If the new location is /profile, show the Profile screen.
      case AppLink.kProfilePath:
        profileManager.tapOnProfile(true);
        break;
      // Check if the new location starts with /item.
      case AppLink.kItemPath:
        // If itemId is not null, set the selected grocery item and show the
        //Grocery Item screen.
        final itemId = newLink.itemId;
        if (itemId != null) {
          groceryManager.setSelectedGroceryItem(itemId);
        } else {
          // If itemId is null, show an empty Grocery Item screen.
          groceryManager.createNewItem();
        }
        // Hide the Profile screen.
        profileManager.tapOnProfile(false);
        break;
      // If the new location is /home.
      case AppLink.kHomePath:
        // Set the currently selected tab.
        appStateManager.goToTab(newLink.currentTab ?? 0);
        // Make sure the Profile screen and Grocery Item screen are hidden.
        profileManager.tapOnProfile(false);
        groceryManager.groceryItemTapped(-1);
        break;
      // If the location does not exist, do nothing.
      default:
        break;
    }
  }
}

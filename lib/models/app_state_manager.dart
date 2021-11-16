import 'dart:async';
import 'package:flutter/material.dart';

// Creates constants for each tab the user taps.
class FooderlichTab {
  static const int explore = 0;
  static const int recipes = 1;
  static const int toBuy = 2;
}

class AppStateManager extends ChangeNotifier {
  // _initialized checks if the app is initialized.
  bool _initialized = false;
  // _loggedIn lets you check if the user has logged in.
  bool _loggedIn = false;
  // _onboardingComplete checks if the user completed the onboarding flow.
  bool _onboardingComplete = false;
  // _selectedTab keeps track of which tab the user is on.
  int _selectedTab = FooderlichTab.explore;

  // These are getter methods for each property.
  //You cannot change these properties outside AppStateManager.
  //This is important for the unidirectional flow architecture, where you don’t
  //change state directly but only via function calls or dispatched events.
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  int get getSelectedTab => _selectedTab;

  void initializeApp() {
    // Sets a delayed timer for 2,000 milliseconds before executing the closure.
    //This sets how long the app screen will display after the user starts the
    //app.
    Timer(
      const Duration(milliseconds: 2000),
      () {
        // Sets initialized to true.
        _initialized = true;
        // Notifies all listeners.
        notifyListeners();
      },
    );
  }

  void login(String username, String password) {
    // Also here you can implement backend logic
    // Sets loggedIn to true.
    _loggedIn = true;
    // Notifies all listeners.
    notifyListeners();
  }

  // Calling completeOnboarding() will notify all listeners that the user has
  //completed the onboarding guide.
  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  void goToRecipes() {
    _selectedTab = FooderlichTab.recipes;
    notifyListeners();
  }

  void logout() {
    // Resets all app state properties.
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = 0;

    // Reinitializes the app.
    initializeApp();
    // Notifies all listeners of state change.
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

import 'app_link.dart';

// AppRouteParser extends RouteInformationParser. Notice it takes a generic type
//In this case, your type is AppLink, which holds all the route and navigation
//information.

class AppRouteParser extends RouteInformationParser<AppLink> {
  // The first method you need to override is parseRouteInformation().
  //The route information contains the URL string.
  @override
  Future<AppLink> parseRouteInformation(
      RouteInformation routeInformation) async {
    // Take the route information and build an instance of AppLink from it.
    final link = AppLink.fromLocation(routeInformation.location);
    return link;
  }

  // The second method you need to override is restoreRouteInformation().
  @override
  RouteInformation restoreRouteInformation(AppLink appLink) {
    // This function passes in an AppLink object. You ask AppLink to give you
    //back the URL string.
    final location = appLink.toLocation();
    // You wrap it in RouteInformation to pass it along.
    return RouteInformation(location: location);
  }
}

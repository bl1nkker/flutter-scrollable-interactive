import 'package:flutter/material.dart';
import 'screens/grocery_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/recipes_screen.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = <Widget>[
    ExploreScreen(),
    RecipesScreen(),
    GroceryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Wraps all the widgets inside Consumer.
    // !When TabManager changes, the widgets below it will rebuild.
    return Consumer<TabManager>(
      builder: (context, tabManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'いくつかのポップミュージック',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          // Displays the correct page widget, based on the current tab index.
          // TODO: Replace body
          body: IndexedStack(index: tabManager.selectedTab, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor:
                Theme.of(context).textSelectionTheme.selectionColor,
            // Sets the current index of BottomNavigationBar.
            currentIndex: tabManager.selectedTab,
            onTap: (index) {
              // Calls manager.goToTab() when the user taps a different tab,
              //to notify other widgets that the index changed.
              tabManager.goToTab(index);
            },
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: 'Music',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Recipes',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'To Buy',
              ),
            ],
          ),
        );
      },
    );
  }
}

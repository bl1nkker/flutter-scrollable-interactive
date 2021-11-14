import 'package:flutter/material.dart';
import '../components/grocery_tile.dart';
import '../models/models.dart';
import 'grocery_items_screen.dart';

class GroceryListScreen extends StatelessWidget {
  final GroceryManager manager;

  // It requires a GroceryManager so it can get the list of grocery items
  //to display in the list.
  const GroceryListScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the list of grocery items from the manager.

    final groceryItems = manager.groceryItems;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // Add ListView.
      child: ListView.separated(
        // Set the number of items in the list.
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          return Dismissible(
            // The dismissible widget includes a Key. Flutter needs this to find
            //and remove the right element in the tree.
            key: Key(item.id),
            // Sets the direction the user can swipe to dismiss.
            direction: DismissDirection.endToStart,
            // Selects the background widget to display behind the widget you’re
            //swiping. In this case, the background widget is red with a white
            //trash can Icon aligned in the center and to the right of the
            //Container.
            background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete_forever,
                    color: Colors.white, size: 50.0)),
            // onDismissed lets you know when the user swiped away a GroceryTile
            onDismissed: (direction) {
              // Lets the grocery manager handle deleting the item, given
              //an index.
              manager.deleteItem(index);
              // Shows a snack bar widget to let the user know which item they
              //deleted.
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} dismissed')));
            },
            // You wrap GroceryTile inside an InkWell.
            child: InkWell(
              child: GroceryTile(
                key: Key(item.id),
                item: item,
                // Return onComplete when the user taps the checkbox.
                onComplete: (change) {
                  // Check if there is a change and update the item’s
                  //isComplete status.
                  if (change != null) {
                    manager.completeItem(index, change);
                  }
                },
              ),
              // When the gesture recognizes a tap, it presents
              //GroceryItemScreen, letting the user edit the current item.
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroceryItemScreen(
                      originalItem: item,
                      // GroceryItemScreen calls onUpdate when the user updates
                      //an item.
                      onUpdate: (item) {
                        // GroceryManager updates the item at the particular ind
                        manager.updateItem(item, index);
                        // Dismisses GroceryItemScreen.
                        Navigator.pop(context);
                      },
                      // onCreate will not be called since you are updating
                      //an existing item.
                      onCreate: (item) {},
                    ),
                  ),
                );
              },
            ),
          );
          // For each item in the list, get the current item and construct
          //a GroceryTile.
        },
        // Space each grocery item 16 pixels apart.
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}

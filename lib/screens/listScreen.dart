import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_1/models/item.dart';
import 'package:task_1/models/modelsController.dart';

class ListScreen extends StatelessWidget {
  final data = Get.put(ModelsController());

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items add yet.'),
    );

    if (data.isLoading.value) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data.groceryItems.isNotEmpty) {
      content = Obx(() => ListView.builder(
          itemCount: data.groceryItems.length,
          itemBuilder: (ctx, index) => Dismissible(
                onDismissed: (direction) {
                  data.removeItem(context, data.groceryItems[index]);
                },
                key: ValueKey(data.groceryItems[index].id),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.purple,
                    child: ListTile(
                      title: Text(
                        data.groceryItems[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: data.groceryItems[index].category.color,
                      ),
                      trailing: Text(
                        data.groceryItems[index].quantity.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              )));
    }
    if (data.error.isNotEmpty) {
      content = Center(
        child: Text(data.error.value),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 17,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'Your List',
                style: TextStyle(fontSize: 20),
              ),
              trailing: IconButton(
                  onPressed: () {
                    data.addItem(context);
                  },
                  icon: Icon(
                    Icons.add_task,
                    color: Colors.green,
                  )),
            ),
          ),
          SizedBox(
            height: 70,
            width: 330,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  //
                },
                decoration: InputDecoration(
                    labelText: 'Search by title',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
          ),
          Expanded(child: content)
        ],
      ),
    );
  }
}

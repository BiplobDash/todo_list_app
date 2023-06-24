import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_1/models/modelsController.dart';

class ListScreen extends StatelessWidget {

  final data = Get.put(ModelsController());

  @override
  Widget build(BuildContext context) {
     Widget content = const Center(
      child: Text('No items add yet.'),
    );

    if (data.isLoading.value) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data.groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: data.groceryItems.length,
          itemBuilder: (ctx, index) => Dismissible(
            onDismissed: (direction) {
              data.removeItem(context, data.groceryItems[index]);
            },
            key: ValueKey(data.groceryItems[index].id),
            child: ListTile(
              title: Obx(() => Text(data.groceryItems[index].name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),)),
              leading: Obx(() => Container(
                width: 24,
                height: 24,
                color: data.groceryItems[index].category.color,
              )),
              trailing: Obx(() => Text(data.groceryItems[index].quantity.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),)),
            ),
          ));
    }
    if (data.error.isNotEmpty) {
      content = Center(
        child: Text(data.error.value),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 17,),
          ListTile(
            title: Text('Your List', style: TextStyle(fontSize: 20),),
            trailing: IconButton(onPressed: (){
              data.addItem(context);
            }, icon: const Icon(Icons.add)),
          ),
          SizedBox(
            height: 70,
            width: 330,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value){},
                decoration: InputDecoration(
                    labelText: 'Search by title',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    )
                ),
              ),
            ),
          ),
          Expanded(
              child: content)
        ],
      ),
      
    );
  }
}

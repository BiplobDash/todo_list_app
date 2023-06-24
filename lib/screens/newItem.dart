import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_1/models/newController.dart';

import '../data/categories.dart';

class NewItem extends StatelessWidget {
  final data = Get.put(NewController());

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: data.formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    data.enteredName.value = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration:
                        const InputDecoration(label: Text("Quantity")),
                        keyboardType: TextInputType.number,
                        initialValue: '1',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid, positive number';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          data.enteredQuantity.value = int.parse(val!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: data.selectedCategory,
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(category.value.title)
                                  ],
                                ),
                              )
                          ],
                          onChanged: (value) {
                              data.selectedCategory = value!;
                          
                          }),
                    )
                  ],
                ),
                const SizedBox(
                  width: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => TextButton(
                        onPressed: data.isSending.value
                            ? null
                            : () {
                          data.formKey.currentState!.reset();
                        },
                        child: const Text('Reset'))),
                    Obx(() => ElevatedButton(
                        onPressed: (){
                          data.isSending.value ? null : data.saveItem(context);
                        },
                        child: data.isSending.value
                            ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                            : const Text('Add Item')))
                  ],
                ),
              ],
            ),
          )));
  }
}

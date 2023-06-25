import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_1/models/item.dart';
import '../data/categories.dart';
import 'package:http/http.dart' as http;
import 'category.dart';

class NewController extends GetxController {
  final formKey = GlobalKey<FormState>().obs;
  RxString enteredName = ''.obs;
  RxInt enteredQuantity = 1.obs;
  var selectedCategory = categories[Categories.vegetables]!;
  RxBool isSending = false.obs;


   void saveItem(context) async {
    if (formKey.value.currentState!.validate()) {
      formKey.value.currentState!.save();
        isSending.value = true;
      final url = Uri.https('online-shop-app-389cf-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': enteredName.value,
            'quantity': enteredQuantity.value,
            'category': selectedCategory.title,
          }));
      final Map<String, dynamic> resData = json.decode(response.body);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: enteredName.value,
          quantity: enteredQuantity.value,
          category: selectedCategory));
    }
  }
}

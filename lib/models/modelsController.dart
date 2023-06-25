import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/categories.dart';
import 'package:quickalert/quickalert.dart';

import '../screens/newItem.dart';
import 'item.dart';

class ModelsController extends GetxController {
  RxList<GroceryItem> groceryItems = <GroceryItem>[].obs;
  RxList<GroceryItem> searchItem = <GroceryItem>[].obs;
  RxBool isLoading = true.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchItem;
    loadItems();
    update();
  }

  void showAlert(context) {
    QuickAlert.show(
        context: context,
        text: "Add Successfully",
        type: QuickAlertType.success);
  }

  void showAlert2(context) {
    QuickAlert.show(
        context: context,
        text: "Remove Successfully",
        type: QuickAlertType.warning);
  }

  void loadItems() async {
    final url = Uri.https('online-shop-app-389cf-default-rtdb.firebaseio.com',
        'shopping-list.json');

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        error.value = 'Failed to fetch data. Please try again later.';
      }

      if (response.body == 'null') {
        isLoading.value = false;
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = <GroceryItem>[].obs;
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));
      }
      groceryItems.value = loadedItems;
      isLoading.value = false;
    } catch (err) {
      error.value = 'Something went wrong!. Please try again later.';
    }
  }

  void addItem(context) async {
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));
    if (newItem == null) {
      return;
    }
    groceryItems.add(newItem);
    update();
    showAlert(context);
  }

  void removeItem(context, GroceryItem item) async {
    final index = groceryItems.indexOf(item);
    groceryItems.remove(item);
    showAlert2(context);
    final url = Uri.https('online-shop-app-389cf-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // Optional : Show error Messge
      groceryItems.insert(index, item);
    }
    update();
  }
}

import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/data/source/source_animal.dart';
import 'package:flutterfire/presentation/page/firestore/add_update_firestore_page.dart';
import 'package:get/get.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({Key? key}) : super(key: key);

  @override
  State<FirestorePage> createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  List<Map<String, dynamic>> list = [];

  getAnimal() async {
    list = await SourceAnimal.gets();
    setState(() {});
  }

  optionMenu(String value, Map animal) {
    if (value == 'update') {
      Get.to(() => AddUpdateFirestorePage(animal: animal))?.then((value) {
        if (value ?? false) {
          // refresh list
          getAnimal();
        }
      });
    } else if (value == 'delete') {
      delete(animal['id']);
    }
  }

  delete(String id) async {
    bool success = await SourceAnimal.delete(id);
    if (success) {
      DInfo.dialogSuccess('Success Delete Animal');
      DInfo.closeDialog(actionAfterClose: () {
        // refresh list
        getAnimal();
      });
    } else {
      DInfo.dialogError('Failed Delete Animal');
      DInfo.closeDialog();
    }
  }

  @override
  void initState() {
    getAnimal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Firestore'),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => const AddUpdateFirestorePage())?.then((value) {
            if (value ?? false) {
              // refresh list
              getAnimal();
            }
          }); //add
        },
      ),
      body: list.isEmpty
          ? DView.empty()
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> animal = list[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(animal['name']),
                  subtitle: Text(animal['type']),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => optionMenu(value, animal),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'update', child: Text('Update')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete')),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

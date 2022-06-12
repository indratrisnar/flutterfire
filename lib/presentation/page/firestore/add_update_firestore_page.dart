import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterfire/data/source/source_animal.dart';
import 'package:get/get.dart';

class AddUpdateFirestorePage extends StatefulWidget {
  const AddUpdateFirestorePage({Key? key, this.animal}) : super(key: key);
  final Map? animal;

  @override
  State<AddUpdateFirestorePage> createState() => _AddUpdateFirestorePageState();
}

class _AddUpdateFirestorePageState extends State<AddUpdateFirestorePage> {
  final controllerFoot = TextEditingController();
  final controllerName = TextEditingController();
  final controllerType = TextEditingController();
  bool hasTail = true;

  addAnimal() async {
    bool success = await SourceAnimal.add({
      'foot': controllerFoot.text,
      'hasTail': hasTail,
      'id': '',
      'name': controllerName.text,
      'type': controllerType.text,
    });
    if (success) {
      DInfo.dialogSuccess('Success Add Animal');
      DInfo.closeDialog(actionAfterClose: () {
        Get.back(result: true);
      });
    } else {
      DInfo.dialogError('Failed Add Animal');
      DInfo.closeDialog();
    }
  }

  updateAnimal() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft(
        widget.animal == null ? 'Add Animal' : 'Update Animal',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DInput(
            controller: controllerFoot,
            title: 'Foot',
            inputType: TextInputType.number,
          ),
          DView.spaceHeight(),
          DInput(
            controller: controllerName,
            title: 'Name',
          ),
          DView.spaceHeight(),
          DInput(
            controller: controllerType,
            title: 'Type',
          ),
          DView.spaceHeight(),
          Row(
            children: [
              const Text('Has Tail: '),
              Expanded(
                child: DropdownButton<bool>(
                  value: hasTail,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (bool? newValue) {
                    setState(() {
                      hasTail = newValue!;
                    });
                  },
                  items:
                      [true, false].map<DropdownMenuItem<bool>>((bool value) {
                    return DropdownMenuItem<bool>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          DView.spaceHeight(),
          ElevatedButton(
            onPressed: () {
              if (widget.animal == null) {
                addAnimal();
              } else {
                updateAnimal();
              }
            },
            child: Text(
              widget.animal == null ? 'Add' : 'Update',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hk4_sallah/shared/components/components.dart';


import '../cubit.dart';

Widget buildDropdownButton({BuildContext? context, String? value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customNormalText(context: context, title: 'Address Type:'),
      SizedBox(
        width: double.infinity,
        child: DropdownButton(
            isExpanded: true,
            value: value,
            icon: Icon(Icons.keyboard_arrow_down),
            onChanged: (newValue) {
              SettingCubit.get(context).setNewDropdownElement(newValue.toString());
            },
            items: SettingCubit.get(context)
                .dropdownElement
                .map<DropdownMenuItem<String>>((element) {
              return DropdownMenuItem(
                child: Text(element),
                value: element,
              );
            }).toList()),
      ),
    ],
  );
}

Widget buildButton({String? title, VoidCallback? onClick}) {
  return MaterialButton(
    color: Colors.green,
    height: 40,
    minWidth: 100,
    child: Text(
      title!,
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    colorBrightness: Brightness.light,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    clipBehavior: Clip.antiAlias,
    onPressed: onClick,
  );
}

import 'dart:convert';
import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EditableMongoDocument extends StatefulWidget {
  final Map<String, dynamic> document;

  final void Function(List<FieldModel> fields) onSave;
  final VoidCallback onCancel;
  final Function(String field) onDeleteField;
  final Function(List<FieldModel> newFields) onAddFieldConfirm;

  const EditableMongoDocument({
    super.key,
    required this.document,
    required this.onSave,
    required this.onCancel,
    required this.onDeleteField,
    required this.onAddFieldConfirm,
  });

  @override
  State<EditableMongoDocument> createState() => _EditableMongoDocumentState();
}

class _EditableMongoDocumentState extends State<EditableMongoDocument> {
  late List<FieldModel> fields;

  bool isAddingField = false;
  FieldModel? newField;

  @override
  void initState() {
    super.initState();

    fields = widget.document.entries.map((e) {
      return FieldModel(key: e.key, value: e.value, type: _detectType(e.value));
    }).toList();
  }

String _detectType(dynamic value) {
  if (value == null) return "string";
  if (value is int) return "int64";
  if (value is double) return "double";
  if (value is bool) return "boolean";
  if (value is List) return "array";
  if (value is Map) return "object";
  return "string";
}
dynamic _parseValue(String val, String type) {
  switch (type) {
    case "int32":
    case "int64":
      return int.tryParse(val) ?? 0;

    case "double":
      return double.tryParse(val) ?? 0.0;

    case "boolean":
      return val.toLowerCase() == "true";

    case "array":
      try {
        return jsonDecode(val);
      } catch (_) {
        return [];
      }

    case "object":
      try {
        return jsonDecode(val);
      } catch (_) {
        return {};
      }

    default:
      return val;
  }
}
 
dynamic _castValue(dynamic value, String newType) {
  value ??= "";

  if (newType == "string") return value.toString();

  if (newType == "int32" || newType == "int64") {
    return int.tryParse(value.toString()) ?? 0;
  }

  if (newType == "double") {
    return double.tryParse(value.toString()) ?? 0.0;
  }

  if (newType == "boolean") {
    return value == true || value.toString() == "true";
  }

  if (newType == "array") {
    return value is List ? value : [];
  }

  if (newType == "object") {
    return value is Map ? value : {};
  }

  return value;
}
  void _startAddField() {
    setState(() {
      isAddingField = true;
      newField = FieldModel(key: "", value: "", type: "string");
    });
  }

  void _confirmAddField() {
    if (newField == null) return;

    setState(() {
      fields.add(newField!);
      isAddingField = false;
      newField = null;
    });

    widget.onAddFieldConfirm(fields);
  }

  void _cancelAddField() {
    setState(() {
      isAddingField = false;
      newField = null;
    });
  }

  void _removeField(int index) {
    final fieldName = fields[index].key;

    setState(() {
      fields.removeAt(index);
    });

    widget.onDeleteField(fieldName);
  }

  @override
  Widget build(BuildContext context) {
        final provider = Provider.of<SettingsProvider>(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
               Text(
                "Edit Document",
                style: TextStyle(fontWeight: FontWeight.bold,color:     provider.isDark ? Colors.white : Colors.black,
),
              ),
              const Spacer(),
              TextButton(

                onPressed: widget.onCancel,
                child:  Text("Cancel",style: TextStyle(    color: provider.isDark ? Colors.white : Colors.black,
),),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onSave(fields);
                },
                child: const Text("Save"),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fields.length + (isAddingField ? 1 : 0),
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
if (isAddingField && index == fields.length) {
  final f = newField!;

  return Row(
    children: [
      Expanded(
        flex: 2,
        child:
        CustomTextFormField(hintText: "New Key",  onChanged: (v) => f.key = v,)
        
        
   
      ),

      SizedBox(width: 10.w),

      DropdownButton<String>(
        value: f.type,
        items: const [
  DropdownMenuItem(value: "int32", child: Text("Int32")),
DropdownMenuItem(value: "int64", child: Text("Int64")),
DropdownMenuItem(value: "double", child: Text("Double")),
DropdownMenuItem(value: "boolean", child: Text("Boolean")),
DropdownMenuItem(value: "array", child: Text("Array")),
DropdownMenuItem(value: "object", child: Text("Object")),
DropdownMenuItem(value: "string", child: Text("String")),
        ],
        onChanged: (val) {
          setState(() {
            f.type = val!;
            f.value = _castValue(f.value, val);
          });
        },
      ),

      SizedBox(width: 10.w),

      Expanded(
        flex: 3,
        child:         
        CustomTextFormField(hintText: "Value",            onChanged: (v) => f.value = _parseValue(v, f.type),)

    
      ),

      SizedBox(width: 10.w),

      IconButton(
        icon: const Icon(Icons.check, color: Colors.green),
        onPressed: _confirmAddField,
      ),

      IconButton(
        icon: const Icon(Icons.close, color: Colors.red),
        onPressed: _cancelAddField,
      ),
    ],
  );
}

              final field = fields[index];

              return Row(
                key: ValueKey(field.key),
                children: [
                  Expanded(
                    flex: 2,
                    child: 
                    
                    
                    
                    
                    TextFormField(
                        style: TextStyle(
    color: provider.isDark ? Colors.white : Colors.black,
  ),
                      initialValue: field.key,
                      decoration: const InputDecoration(labelText: "Key"),
                      onChanged: (val) => field.key = val,
                    ),
                  ),

                  SizedBox(width: 10.w),

DropdownButton<String>(
  value: field.type,
  items: const [
    DropdownMenuItem(value: "string", child: Text("String")),
    DropdownMenuItem(value: "int32", child: Text("Int32")),
    DropdownMenuItem(value: "int64", child: Text("Int64")),
    DropdownMenuItem(value: "double", child: Text("Double")),
    DropdownMenuItem(value: "boolean", child: Text("Boolean")),
    DropdownMenuItem(value: "array", child: Text("Array")),
    DropdownMenuItem(value: "object", child: Text("Object")),
  ],
  onChanged: (val) {
    setState(() {
      field.type = val!;
      field.value = _castValue(field.value, val);
    });
  },
),

                  SizedBox(width: 10.w),

                  Expanded(
                    flex: 3,
                    child: TextFormField(
                        style: TextStyle(
    color: provider.isDark ? Colors.white : Colors.black,
  ),
                      initialValue: field.value?.toString() ?? "",
                      onChanged: (val) {
                        field.value = _parseValue(val, field.type);
                      },
                    ),
                  ),

                  SizedBox(width: 10.w),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeField(index),
                  ),
                ],
              );
            },
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _startAddField,
              icon: const Icon(Icons.add,color: AppTheme.black,),
              label:  Text("Add Field",style: TextStyle(    color: provider.isDark ? Colors.white : Colors.black,
),),
            ),
          ),
        ],
      ),
    );
  }
}

class FieldModel {
  String key;
  dynamic value;
  String type;

  FieldModel({required this.key, required this.value, required this.type});
}

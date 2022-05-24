import 'dart:io';

import 'package:aqniyet/components/auth_required_state.dart';
import 'package:aqniyet/components/model_validator.dart';
import 'package:aqniyet/model/advert.dart';
import 'package:aqniyet/model/category.dart';
import 'package:aqniyet/model/city.dart';
import 'package:aqniyet/model/phonecode.dart';
import 'package:aqniyet/pages/main_page.dart';
import 'package:aqniyet/utils/constants.dart';
import 'package:aqniyet/widgets/checkbox_from_input.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../services/app_service.dart';

class AddPage extends StatefulWidget {
  static String routeName = '/add';
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends AuthRequiredState<AddPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _enabled = true;
  Category? _category;
  City? _city;
  PhoneCode? _phoneCode;
  final List<XFile> _images = [];

  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        isAuthenticated()) {
      _formKey.currentState!.save();

      if (_category != null && _city != null && _phoneCode != null) {
        final model = Advert(
          id: '',
          categoryId: _category!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          cityId: _city!.id,
          address: _addressController.text,
          phoneCodeId: _phoneCode!.id,
          phone: _phoneController.text,
          enabled: _enabled,
          createdBy: getCurrentUserId(),
        );

        final response = await context.read<AppService>().createAdvert(model);
        final error = response.error;
        if (response.hasError) {
          context.showErrorSnackBar(message: error!.message);
        } else {
          final advertId =
              (((response.data) as List<dynamic>)[0]['id']) as String;

          for (var image in _images) {
            await _saveImage(advertId, image);
          }

          context.showSnackBar(message: 'You created a new item');
          Navigator.of(context).pushReplacementNamed(MainPage.routeName);
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveImage(String advertId, XFile file) async {
    final response = await supabase.storage.from('public-images').upload(
        '${getCurrentUserId()}/$advertId/${file.name}', File(file.path));

    final error = response.error;
    if (response.hasError) {
      context.showErrorSnackBar(message: error!.message);
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? pickedPhoto =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedPhoto != null) {
        setState(() {
          _images.add(pickedPhoto);
        });
      }
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error');
    }
  }

  Future<void> _getImagesFromGallery() async {
    try {
      final List<XFile>? pickedPhotos = await _picker.pickMultiImage();

      if (pickedPhotos != null) {
        setState(() {
          _images.addAll(pickedPhotos);
        });
      }
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error');
    }
  }

  Future<void> _showOption() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _getImagesFromGallery();
              },
              child: const Text('Gallery')),
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _takePicture();
              },
              child: const Text('Camera')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New advert'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  autocorrect: false,
                  validator: RequiredValidator(errorText: 'Name is required'),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 20),
                DropdownSearch<Category>(
                  key: const ValueKey('category'),
                  mode: Mode.DIALOG,
                  enabled: !_isLoading,
                  dropdownSearchDecoration:
                      const InputDecoration(labelText: 'Category'),
                  showSearchBox: true,
                  isFilteredOnline: true,
                  itemAsString: (Category? model) => model!.name,
                  onFind: (String? filter) => context
                      .read<AppService>()
                      .getCategoryList(filter: filter),
                  dropdownBuilder: (ctx, Category? model) =>
                      model == null ? const Text('') : Text(model.name),
                  onSaved: (val) => _category = val,
                  validator: ModelValidator(errorText: 'Category is required'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  autocorrect: false,
                  validator:
                      RequiredValidator(errorText: 'Description is required'),
                  enabled: !_isLoading,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                DropdownSearch<City>(
                  key: const ValueKey('city'),
                  mode: Mode.DIALOG,
                  enabled: !_isLoading,
                  dropdownSearchDecoration:
                      const InputDecoration(labelText: 'City'),
                  showSearchBox: true,
                  isFilteredOnline: true,
                  itemAsString: (City? model) => model!.name,
                  onFind: (String? filter) =>
                      context.read<AppService>().getCityList(filter: filter),
                  dropdownBuilder: (ctx, City? model) =>
                      model == null ? const Text('') : Text(model.name),
                  onSaved: (val) => _city = val,
                  validator: ModelValidator(errorText: 'City is required'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  autocorrect: false,
                  validator: (val) => null,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownSearch<PhoneCode>(
                        key: const ValueKey('phoneCode'),
                        mode: Mode.DIALOG,
                        enabled: !_isLoading,
                        dropdownSearchDecoration:
                            const InputDecoration(labelText: 'Phone code'),
                        showSearchBox: true,
                        isFilteredOnline: true,
                        itemAsString: (PhoneCode? model) => model!.getName(),
                        onFind: (String? filter) => context
                            .read<AppService>()
                            .getPhoneCodeList(filter: filter),
                        dropdownBuilder: (ctx, PhoneCode? model) =>
                            model == null ? const Text('') : Text(model.code),
                        onSaved: (val) => _phoneCode = val,
                        validator:
                            ModelValidator(errorText: 'Phone code is required'),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        autocorrect: false,
                        validator:
                            RequiredValidator(errorText: 'Phone is required'),
                        enabled: !_isLoading,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _showOption,
                  child: const Text('Take a photo'),
                ),
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    ..._images.map((e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.file(
                            File(e.path),
                            width: 20.w,
                            height: 20.w,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                CheckboxFormInput(
                  title: 'Enable',
                  onSaved: (val) => _enabled = val ?? false,
                  validator: (c) => null,
                  enabled: !_isLoading,
                  initialValue: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _isLoading ? null : _saveData,
                    child: Text(_isLoading ? 'Loading' : 'Save')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

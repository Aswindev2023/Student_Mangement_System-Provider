import 'package:flutter/material.dart';

class StudentProvider with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _batchController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get addressController => _addressController;
  TextEditingController get contactController => _contactController;
  TextEditingController get batchController => _batchController;
  GlobalKey<FormState> get formKey => _formKey;

  void clearText() {
    _nameController.clear();
    _addressController.clear();
    _contactController.clear();
    _batchController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _batchController.dispose();
    super.dispose();
  }
}

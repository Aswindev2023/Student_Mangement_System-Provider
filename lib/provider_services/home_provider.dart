import 'package:flutter/material.dart';
import 'package:student_provider/model/user.dart';
import 'package:student_provider/services/user_service.dart';

class HomeProvider with ChangeNotifier {
  List<User> _userList = [];
  List<User> _filteredUserList = [];
  bool _isSearching = false;
  bool _isGridView = false;

  final _userService = UserService();

  List<User> get userList => _userList;
  List<User> get filteredUserList => _filteredUserList;
  bool get isSearching => _isSearching;
  bool get isGridView => _isGridView;

  HomeProvider() {
    getAllUserDetails();
  }

  Future<void> getAllUserDetails() async {
    _userList = [];
    var users = await _userService.readAllUser();

    users.forEach((student) {
      var studentModel = User();
      studentModel.id = student['id'];
      studentModel.name = student['name'];
      studentModel.batch = student['batch'];
      studentModel.contact = student['contact'];
      studentModel.address = student['address'];
      studentModel.imagePath = student['imagePath'] ?? '';

      _userList.add(studentModel);
    });
    _filteredUserList = List.from(_userList);
    notifyListeners();
  }

  void updateDisplayedUsers(String query) {
    _isSearching = query.isNotEmpty;

    _filteredUserList = _userList.where((user) {
      final userName = user.name?.trim().toLowerCase() ?? '';
      final searchQuery = query.trim().toLowerCase();

      return userName.contains(searchQuery);
    }).toList();

    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _filteredUserList = List.from(_userList);
    notifyListeners();
  }

  void toggleView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _userService.deleteUser(userId); // Update the database
      _userList.removeWhere((user) => user.id == userId);
      _filteredUserList = List.from(_userList);
      notifyListeners();
    } catch (e) {
      throw Exception('failed to delete');
    }
  }

  void updateUserList(User updatedUser) {
    var index = _userList.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _userList[index] = updatedUser;
      _filteredUserList = List.from(_userList);
      notifyListeners();
    }
  }
}

import 'package:student_provider/db_helper/repository.dart';
import 'package:student_provider/model/user.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }
//save user
  saveUser(User user) async {
    return await _repository.insertData("Students", user.userMap());
  }

//read user
  readAllUser() async {
    return await _repository.readData('Students');
  }

//edit user
  // UpdateUser method in UserService
  updateUser(User user) async {
    if (user.id != null) {
      // print('Updating user: $user');
      return await _repository.updateData('Students', user.userMap());
    } else {
      print('Cannot update user with null id.');
      return null; // or handle the case differently
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _repository.deleteDataById('Students', userId);
      print('User deleted: $userId');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}

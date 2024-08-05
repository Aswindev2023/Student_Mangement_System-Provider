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
      return await _repository.updateData('Students', user.userMap());
    } else {
      return null;
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _repository.deleteDataById('Students', userId);
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}

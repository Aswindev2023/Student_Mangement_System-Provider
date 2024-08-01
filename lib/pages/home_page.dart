import 'package:flutter/material.dart';
import 'dart:io';
import 'package:student_provider/model/user.dart';
import 'package:student_provider/pages/add_student.dart';
import 'package:student_provider/pages/edit_user.dart';
import 'package:student_provider/pages/view_user.dart';
import 'package:student_provider/services/user_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<User> _userList;
  List<User> _filteredUserList = [];
  final _userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isGridView = false;

  getAllUserDetails() async {
    _userList = <User>[];
    var users = await _userService.readAllUser();

    users.forEach((student) {
      var studentModel = User();
      studentModel.id = student['id'];
      studentModel.name = student['name'];
      studentModel.batch = student['batch'];
      studentModel.contact = student['contact'];
      studentModel.address = student['address'];
      studentModel.imagePath = student['imagePath'] ?? '';

      setState(() {
        _userList.add(studentModel);
        _filteredUserList = List.from(_userList);
      });
    });
  }

  void _updateDisplayedUsers(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      // Filter the list based on the search query
      _filteredUserList = _userList.where((user) {
        return user.name?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _updateDisplayedUsers('');
    });
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Updated method for updating the user list
  void _updateUserList(User updatedUser) {
    setState(() {
      var index = _userList.indexWhere((user) => user.id == updatedUser.id);
      if (index != -1) {
        _userList[index] = updatedUser;
        _filteredUserList = List.from(_userList);
      }
    });
  }

  // Updated method for deleting the user
  void _deleteUser(int userId) {
    setState(() {
      _userList.removeWhere((user) => user.id == userId);
      _filteredUserList = List.from(_userList);
    });
  }

  //List View
  Widget _buildListTile(int index) {
    return Card(
      child: ListTile(
        onTap: () {
          print('Image Path: ${_filteredUserList[index].imagePath}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewUser(user: _filteredUserList[index]),
            ),
          );
        },
        leading: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: _filteredUserList[index].imagePath != null
                  ? FileImage(File(_filteredUserList[index].imagePath!))
                  : AssetImage('assets/background.jpg')
                      as ImageProvider, // Provide a default image
            ),
          ],
        ),
        title: Text(_filteredUserList[index].name ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                /* print(
                    'Navigating to EditUser with id: ${_filteredUserList[index].id}');*/
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUser(
                              user: _filteredUserList[index],
                            ))).then((data) {
                  if (data != null) {
                    getAllUserDetails();
                    _showSuccessSnackBar(
                        'Student details Updated Successfully');
                  }
                });
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.teal,
              ),
            ),
            IconButton(
              onPressed: () {
                _deleteFormDialoge(context, _filteredUserList[index].id);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

//Grid View
  Widget _buildGridTile(int index) {
    return Card(
      child: InkWell(
        onTap: () {
          // print('Image Path: ${_filteredUserList[index].imagePath}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewUser(user: _filteredUserList[index]),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: _filteredUserList[index].imagePath != null
                    ? FileImage(File(_filteredUserList[index].imagePath!))
                    : AssetImage('assets/background.jpg')
                        as ImageProvider, // Provide a default image
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_filteredUserList[index].name ?? ''),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    //print('Navigating to EditUser with id: ${_filteredUserList[index].id}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditUser(
                                  user: _filteredUserList[index],
                                ))).then((data) {
                      if (data != null) {
                        getAllUserDetails();
                        _showSuccessSnackBar(
                            'Student details Updated Successfully');
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.teal,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _deleteFormDialoge(context, _filteredUserList[index].id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getAllUserDetails();
    super.initState();
  }

  void _deleteFormDialoge(BuildContext context, userId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (param) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to Delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var result = await _userService.deleteUser(userId);
                if (result != null) {
                  setState(() {
                    Navigator.of(context).pop();
                    getAllUserDetails();
                    _showSuccessSnackBar(
                        'Student details deleted Successfully');
                  });
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _clearSearch();
                },
              )
            : null,
        title: Text(
          _isSearching ? 'Search Results' : 'Students',
        ),
        backgroundColor: Color.fromARGB(255, 249, 255, 71),
        actions: [
          IconButton(
            icon: _isGridView ? Icon(Icons.list) : Icon(Icons.grid_on),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            onPressed: () {
              _showSearchDialog(context);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: _filteredUserList.isEmpty
          ? Center(
              child: Text(
                'No students available.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : _isGridView
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _filteredUserList.length,
                  itemBuilder: (context, index) {
                    return _buildGridTile(index);
                  },
                )
              : ListView.builder(
                  itemCount: _filteredUserList.length,
                  itemBuilder: (context, index) {
                    return _buildListTile(index);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddStudent()))
              .then((data) {
            if (data != null) {
              getAllUserDetails();
              _showSuccessSnackBar('Student details added Successfully');
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Students'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by Name',
                  hintText: 'Enter student name',
                ),
                onChanged: _updateDisplayedUsers,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  _updateDisplayedUsers(_searchController.text);
                },
                child: Text('Search'),
              ),
            ],
          ),
        );
      },
    );
  }
}

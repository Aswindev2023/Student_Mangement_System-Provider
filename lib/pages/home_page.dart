import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:student_provider/pages/add_student.dart';
import 'package:student_provider/pages/edit_user.dart';
import 'package:student_provider/pages/view_user.dart';
import 'package:student_provider/provider_services/home_provider.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<HomeProvider>(
          builder: (context, homeProvider, _) {
            return homeProvider.isSearching
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      homeProvider.clearSearch();
                    },
                  )
                : const SizedBox();
          },
        ),
        title: Consumer<HomeProvider>(
          builder: (context, homeProvider, _) {
            return Text(
              homeProvider.isSearching ? 'Search Results' : 'Students',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 249, 255, 71),
        actions: [
          Consumer<HomeProvider>(
            builder: (context, homeProvider, _) {
              return IconButton(
                icon: homeProvider.isGridView
                    ? const Icon(Icons.list)
                    : const Icon(Icons.grid_on),
                onPressed: () {
                  homeProvider.toggleView();
                },
              );
            },
          ),
          IconButton(
            onPressed: () {
              _showSearchDialog(context);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          return homeProvider.filteredUserList.isEmpty
              ? const Center(
                  child: Text(
                    'No students available.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : homeProvider.isGridView
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: homeProvider.filteredUserList.length,
                        itemBuilder: (context, index) {
                          return _buildGridTile(context, index, homeProvider);
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        itemCount: homeProvider.filteredUserList.length,
                        itemBuilder: (context, index) {
                          return _buildListTile(context, index, homeProvider);
                        },
                      ),
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudent(),
            ),
          ).then((data) {
            if (data != null) {
              context.read<HomeProvider>().getAllUserDetails();
              _showSuccessSnackBar(
                  context, 'Student details added Successfully');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, int index, HomeProvider homeProvider) {
    final user = homeProvider.filteredUserList[index];
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewUser(user: user),
            ),
          );
        },
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: user.imagePath != null
              ? FileImage(File(user.imagePath!))
              : const AssetImage('assets/background.jpg') as ImageProvider,
        ),
        title: Text(user.name ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditUser(user: user)),
                ).then((data) {
                  if (data != null) {
                    homeProvider.getAllUserDetails();
                    _showSuccessSnackBar(
                        context, 'Student details Updated Successfully');
                  }
                });
              },
              icon: const Icon(Icons.edit, color: Colors.blue),
            ),
            IconButton(
              onPressed: () {
                homeProvider.deleteUser(user.id!);
                _showSuccessSnackBar(context, 'Student details Deleted');
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(
      BuildContext context, int index, HomeProvider homeProvider) {
    final user = homeProvider.filteredUserList[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewUser(user: user)),
        );
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Expanded(
              child: Image.file(
                File(user.imagePath!),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user.name ?? '',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUser(user: user)),
                    ).then((data) {
                      if (data != null) {
                        homeProvider.getAllUserDetails();
                        _showSuccessSnackBar(
                            context, 'Student details Updated Successfully');
                      }
                    });
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    homeProvider.deleteUser(user.id!);
                    _showSuccessSnackBar(context, 'Student details Deleted');
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Students'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter student name',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                final query = searchController.text.trim();
                homeProvider.updateDisplayedUsers(query);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

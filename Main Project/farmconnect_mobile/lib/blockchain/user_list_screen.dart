import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmconnect/blockchain/add_user_screen.dart';
import 'package:farmconnect/blockchain/user_details_screen.dart';
import 'package:farmconnect/blockchain/web3client.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserServices>(
      builder: (context, userServices, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              'User Data Stored on Blockchain',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blueGrey[900],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10), // Added space between AppBar and ListView
                Expanded(
                  child: userServices.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : userServices.users.isEmpty
                      ? Center(
                    child: Text(
                      'The Blockchain is Empty\nNo Events to Display',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: userServices.users.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailsScreen(
                                  user: userServices.users[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            color: Colors.blueGrey,
                            child: ListTile(
                              title: Text(
                                userServices.users[index].name,
                                style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                userServices.users[index].fuid,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              trailing: Icon(Icons.open_in_full, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: EdgeInsets.all(16),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserScreen()),
                );
              },
              backgroundColor: Colors.green,
              icon: Icon(Icons.add),
              label: Text(
                'Add User Data to Blockchain',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }
}

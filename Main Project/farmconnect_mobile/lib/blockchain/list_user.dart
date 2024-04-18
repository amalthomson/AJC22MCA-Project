import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmconnect/blockchain/add_user.dart';
import 'package:farmconnect/blockchain/user_details.dart';
import 'package:farmconnect/blockchain/web3client.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserServices>(
      builder: (context, userServices, _) {
        return Scaffold(
          backgroundColor: Colors.blueGrey[900],
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            title: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.lock_person,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8,),
                Text(
                  "User Data on Blockchain",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            centerTitle: true, // Center the title horizontally
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(10.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.blueGrey[900]!,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                height: 5.0,
              ),
            ),
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
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                userServices.users[index].name,
                                style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                userServices.users[index].fuid,
                                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              trailing: Icon(Icons.open_in_full, color: Colors.black),
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
        );
      },
    );
  }
}

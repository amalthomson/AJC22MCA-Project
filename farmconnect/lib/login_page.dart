import 'package:flutter/material.dart';
import 'register_page.dart';
import 'main.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/'); // Redirect to the welcome page
          },
          child: Icon(Icons.arrow_back), // Back button icon
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/'); // Redirect to the welcome page
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.home), // Add a home icon for redirection
            ),
          ),
        ],
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {

              String email = _emailController.text;
              String password = _passwordController.text;

              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: Text('Login'),
          ),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text(
              'New to FarmConnect? Register Now',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

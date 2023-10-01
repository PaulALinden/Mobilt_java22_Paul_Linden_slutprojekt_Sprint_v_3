import 'package:flutter/material.dart';
import 'package:sprint_v3/controller/user_controller.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final UserController _userController;

  @override
  void initState() {
    // Initializing text controllers
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _userController = UserController();
  }

  void _register() async {
    // Retrieve the entered username and password
    String username = _nameController.text.toLowerCase();
    String password = _passwordController.text.toLowerCase();
print(username);
    // Create a new user
    _userController.createNewUser(name: username, password: password);
    // Pop the current page to go back to the previous screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Disposing text controllers to prevent memory leaks
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

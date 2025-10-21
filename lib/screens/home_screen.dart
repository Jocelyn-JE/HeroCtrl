import 'package:flutter/material.dart';
import 'package:heroctrl/widgets/password_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _RegisterHomeScreenState();
}

class _RegisterHomeScreenState extends State<HomeScreen> {
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HeroCtrl')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to HeroCtrl!'),
            PasswordField(
              controller: _passwordController,
              labelText: 'Password',
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                // Handle password submission logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}

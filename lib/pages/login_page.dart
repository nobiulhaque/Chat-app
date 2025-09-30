import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  LoginPage({super.key});

// Login Method
void login(BuildContext context) async {
  final authservice = AuthService();
  try {
    await authservice.signInWithEmailPassword(
      _emailcontroller.text.trim(),
      _passwordcontroller.text.trim(),
    );
    // ✅ No manual navigation needed
    // AuthGate + Provider will handle switching to HomePage
  } catch (e) {
    print("❌ Login failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

  // Register Method
  void register(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email text field
            MyTextfield(
              hintText: 'Enter Your Email',
              obscureText: false,
              controller: _emailcontroller,
            ),
            const SizedBox(height: 10),
            // Password text field
            MyTextfield(
              hintText: 'Enter Your Password',
              obscureText: true,
              controller: _passwordcontroller,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  // Login
                  child: myButton(text: 'Log In', onTap: () => login(context)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Register
                  child: myButton(
                    text: "Register now",
                    onTap: () => register(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

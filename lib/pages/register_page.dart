import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameregcontroller = TextEditingController();
  final TextEditingController emailregcontroller = TextEditingController();
  final TextEditingController passwordregcontroller = TextEditingController();
  final TextEditingController conf_passwordregcontroller =
      TextEditingController();

  RegisterPage({super.key});

  //Register Method
  Future<void> register(BuildContext context) async {
    final auth = AuthService();

    // check confirm password here
    if (passwordregcontroller.text != conf_passwordregcontroller.text) {
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Passwords don't match!")),
      );
      return;
    }

    try {
      await auth.signUp(
        name: nameregcontroller.text.trim(),
        email: emailregcontroller.text.trim(),
        password: passwordregcontroller.text.trim(),
        confirmPassword: conf_passwordregcontroller.text.trim(),
      );

      // ✅ go to sign in page after success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
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
            //Name text field
            MyTextfield(
              hintText: 'Enter Your Name',
              obscureText: false,
              controller: nameregcontroller,
            ),
            const SizedBox(height: 10),

            //Email text field
            MyTextfield(
              hintText: 'Enter Your Email',
              obscureText: false,
              controller: emailregcontroller,
            ),
            const SizedBox(height: 10),

            //PassWor text field
            MyTextfield(
              hintText: 'Enter Your Password',
              obscureText: true,
              controller: passwordregcontroller,
            ),
            const SizedBox(height: 10),

            //Confirm PassWor text field
            MyTextfield(
              hintText: 'Confirm Your Password',
              obscureText: true,
              controller: conf_passwordregcontroller,
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  // Login
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                      padding: const EdgeInsets.all(20),

                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Register
                  child: myButton(
                    text: "Register",
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // sign user in
  void signIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      //display error message
      displayMessage(e.code);
    }
  }

  //display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align children to the left
              children: [
                // Log in title at the left top corner
                Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'By continuing, you agree to our User Agreement and Privacy Policy.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 20.0),

                // Email address TextField
                MyTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  obscureText: false,
                ),

                SizedBox(height: 20.0),

                // Password TextField
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: 20.0),

                // Sign in button
                MaterialButton(
                  onPressed: signIn,
                  child: Text(
                    'Log in',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  color: Colors.grey[900],
                  minWidth: double.infinity,
                  padding: EdgeInsets.all(15.0),
                ),

                SizedBox(height: 20.0),

                // Sample text below the login section

                SizedBox(height: 20.0),

                // Go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget
                          .onTap, // Assuming onTap is a callback to navigate to the register page
                      child: Text(
                        'Register here',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

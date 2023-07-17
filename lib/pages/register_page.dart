import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();
//instance of firestore
  final FirebaseFirestore _firestoregetUser = FirebaseFirestore.instance;
  // sign user up

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordController.text != confirmPasswordTextController.text) {
      // pop loading circle
      Navigator.pop(context);
      displayMessage("Password don't match!");
      return;
    }

    //try creating user
    try {
      // create the user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      // after create the user, create a new document for the user in the users collection

      // after creating the user, create a new document in cloiud firestor called  Users
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({
        'username': emailController.text.split('@')[0], // initial username
        'bio': 'Empty bio..', // initially empty bio
        'uid': userCredential.user!.uid,
        'email': emailController.text,
        // add any additional fields as needed
      }, SetOptions(merge: true));

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      //show error to user
      displayMessage(e.code);
    }
  }

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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20.0),

                // Message
                Text(
                  'Let\'s create an account for you',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
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

                // Confirm Password TextField
                MyTextField(
                  controller: confirmPasswordTextController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                SizedBox(height: 20.0),

                // Sign up/register button
                MaterialButton(
                  onPressed: signUp,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.grey[900],
                  minWidth: double.infinity,
                  padding: EdgeInsets.all(15.0),
                ),

                SizedBox(height: 20.0),

                // Go to login page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an account?",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget
                          .onTap, // Assuming onTap is a callback to navigate to the login page
                      child: Text(
                        'Log in',
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

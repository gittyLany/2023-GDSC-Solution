import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle/auth/signup.dart';
import 'package:turtle/services/functions/authentication_services.dart';
import 'package:turtle/utils/images.dart';

import '../pages/world_select/main_world.dart';
import '../utils/current_user.dart';

class BoardingScreen extends StatefulWidget {

  /// First Screen users see
  const BoardingScreen({super.key});
  
  @override
  State<BoardingScreen> createState() => _BoardingState();

}

class _BoardingState extends State<BoardingScreen> {

  final TextEditingController emailController = TextEditingController(); // Gets text from email
  final TextEditingController passwordController = TextEditingController(); // Gets text from password
  final _formKey = GlobalKey<FormState>(); // Checks if form is valid

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: Form (
          key: _formKey,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 250,
                    vertical: 100
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    // Giant turtle logo
                    AppImages.logo,

                    const SizedBox(height: 15),

                    // Email
                    _buildEmailTextField(),

                    const SizedBox(height: 25), // Gap between email and password

                    // Password field
                    _buildPasswordField(),

                    // Contains guest and login button
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 10),

                          // Guest button
                          _buildGuestButton(),

                          const SizedBox(width: 20, height: 50), // Space between guest and login button

                          // Login button
                          _buildLoginButton(),
                        ]
                    ),

                    //SizedBox
                    const SizedBox(height: 50), // Gap between login and sign up button
                    _buildSignUpButton()
                  ],
                ),

              ),
            ],
          ),
        )
      )

    );
  }

  Widget _buildEmailTextField() {
    return                     // Email
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Email",
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(66, 248, 247, 247),
                      blurRadius: 6,
                      offset: Offset(0,2)
                  )
                ]
            ),
            height: 40,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              controller: emailController,
              keyboardType: TextInputType.text,
              obscureText: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.face),
                hintText: "Email",
              ),
            ),
          ),
        ],
      );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Password",
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(66, 248, 247, 247),
                    blurRadius: 6,
                    offset: Offset(0,2)
                )
              ]
          ),
          height: 40,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter password";
              }
              return null;
            },
            controller: passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: "Password",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestButton() {
    return ElevatedButton(style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 221, 160, 62),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
        onPressed: ()  {

          CurrentUser.guest = true;
          /* loads level selection as new player */
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainWorldScreen()));

        },
        child: const Text('Guest Login')
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 221, 160, 62),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
        onPressed: () {

          // CHECK IF THE LOGIN MATCHES ANY IN THE DATA BASE~~~!!!
          /*loads to level selection of old user and above calling it, send info to back end ;p*/
          if (_formKey.currentState!.validate()) {
            context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
          }
        },
        child: const Text('Login'));
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 221, 160, 62),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            // Sign up screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
          },

          child: const Text('Sign Up')

      ),
    );
  }


}





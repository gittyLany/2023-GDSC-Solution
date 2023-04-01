import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turtle/auth/boarding.dart';
import 'package:turtle/pages/world_select/main_world.dart';
import 'package:turtle/services/functions/authentication_services.dart';


class SignupScreen extends StatefulWidget{

  ///
  /// For the user to create their own account
  /// <p>
  /// Will validate email and ensure password is valid
  /// <p>
  /// Directs user to home screen on completion
  /// <p>
  /// NextSteps -> separate code into methods -> it's messy because it's early code
  ///
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupPaneState();
  
}

class _SignupPaneState extends State<SignupScreen> {

  final TextEditingController emailController = TextEditingController(); // Gets text from email
  final TextEditingController passwordController = TextEditingController(); // Gets text from password
  final TextEditingController rePasswordController = TextEditingController(); // Gets text from reentering password
  final _formKey = GlobalKey<FormState>(); // Checks if form is valid
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 150
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      // Back button
                      _buildBackButton(),

                      const SizedBox(height: 25),
                      const Text(
                        'Sign Up',
                        //style: signup_text,
                      ),
                      const SizedBox(height: 15),

                      // Email
                     Form(
                       key: _formKey,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           const Text(
                            'Enter Email',
                              //style: signup_text,
                           ),
                           const SizedBox(height: 10),
                           Container(
                             alignment: Alignment.centerLeft,
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0,2)
                                    )
                                ]
                             ),
                             height: 60,
                             child: TextFormField(
                               validator: validateEmail,
                               controller: emailController,
                               keyboardType: TextInputType.emailAddress,
                               decoration: const InputDecoration(
                                 prefixIcon: Icon(
                                     Icons.email
                                 ),
                                 hintText: 'Email',
                                 //hintStyle:
                                ),
                             ),
                           ),

                           // Space between email and password
                           const SizedBox(height: 30),

                           // Password 1
                           const Text(
                             'Enter Password',
                             //style: signup_text,
                           ),
                           const SizedBox(height: 10),
                           Container(
                             alignment: Alignment.centerLeft,
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(10),
                                 boxShadow: const [BoxShadow(
                                     color: Colors.black26,
                                     blurRadius: 6,
                                     offset: Offset(0,2)
                                 )
                                 ]
                             ),
                             height: 60,
                             child: TextFormField(
                               obscureText: true,
                               validator: (value) {
                                 if (value == null || value.isEmpty) {
                                   return 'Please enter password';
                                 }
                                 else if (value != rePasswordController.text) {
                                   return "Password does not match";
                                 }
                                 return null;
                               },
                               controller: passwordController,
                               keyboardType: TextInputType.text,
                               decoration: const InputDecoration(
                                 prefixIcon: Icon(
                                     Icons.lock
                                 ),
                                 hintText: 'Password',
                                 //hintStyle:
                               ),
                             ),
                           ),

                           // Space between password and re-password
                           const SizedBox(height: 30),

                           // Re-enter password
                           const Text(
                             'Re-Enter Password',
                             //style: signup_text,
                           ),
                           const SizedBox(height: 10),
                           Container(
                             alignment: Alignment.centerLeft,
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(10),
                                 boxShadow: const [BoxShadow(
                                     color: Colors.black26,
                                     blurRadius: 6,
                                     offset: Offset(0,2)
                                 )
                                 ]
                             ),
                             height: 60,
                             child: TextFormField(
                               obscureText: true,
                               validator: (value) {
                                 if (value == null || value.isEmpty) {
                                   return 'Please re-enter password';
                                 }
                                 else if (value != passwordController.text) {
                                   return "Password does not match";
                                 }
                                 return null;
                               },
                               controller: rePasswordController,
                               keyboardType: TextInputType.text,
                               decoration: const InputDecoration(
                                 prefixIcon: Icon(
                                     Icons.lock
                                 ),
                                 hintText: 'Password',
                                 //hintStyle:
                               ),
                             ),
                           ),
                           const SizedBox(height: 30), // Gap between re enter password and create button

                           // ---- Sign up Button -------
                           SizedBox(
                             width: double.infinity,
                             child: ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: const Color.fromARGB(255, 221, 160, 62),
                                   alignment: Alignment.bottomCenter,
                                   padding: const EdgeInsets.all(15),
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                 ),
                                 onPressed: () async {
                                   if (_formKey.currentState!.validate()) {

                                     String? message = await context.read<AuthenticationService>().signUp(
                                         email: emailController.text,
                                         password: passwordController.text);

                                     if (message == "Signed up") {
                                      if (context.mounted) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainWorldScreen()));
                                      }
                                     }
                                   }
                                 },

                                 child: const Text('Create Account')

                             ),
                           )
                        ],
                      ),
                     ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BoardingScreen()));
            },
            child: const Text('Back'))
    );
  }
}

// https://stackoverflow.com/questions/63292839/how-to-validate-email-in-a-textformfield
String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}



